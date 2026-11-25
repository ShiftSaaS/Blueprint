#!/usr/bin/env node
// Live session heartbeat — blueprint v2.0 (from Lintent Landing L0.3 / L0.4, 2026-11-16).
// Claude Code runs this on UserPromptSubmit, PreToolUse, PostToolUse(Failure), Stop and StopFailure.
// Each session writes only docs/status/.live/<tool>-<session>.json; on a prompt it first prints a summary
// of every repo in LIVE_REPOS (added to the model's context), then records the new command. It never blocks: exit 0.

import fs from 'node:fs';
import path from 'node:path';

const STALE_MS = 10 * 60 * 1000;          // owner check d
const KEEP_ENDED_MS = 24 * 60 * 60 * 1000; // confirmed-ended records older than this are removed
// The sibling repos to report, as folder names beside this one: LIVE_REPOS="Code,API,Landing". Default: this repo only.
const REPOS = (process.env.LIVE_REPOS || path.basename(process.env.CLAUDE_PROJECT_DIR || process.cwd())).split(',').map((s) => s.trim()).filter(Boolean);
// L0.4 — one hook for both tools: Claude Code runs it as is; Codex runs it from .codex/hooks.json with LIVE_TOOL=codex.
const TOOL = process.env.LIVE_TOOL === 'codex' ? 'codex' : 'claude';

const root = process.env.CLAUDE_PROJECT_DIR || process.cwd();
const liveDir = (repoRoot) => path.join(repoRoot, 'docs', 'status', '.live');
const repoRoot = (name) => (name === path.basename(root) ? root : path.join(root, '..', name));

const now = () => new Date();
const hhmm = (iso) => {
  const d = new Date(iso);
  return Number.isNaN(d.getTime()) ? '?' : d.toTimeString().slice(0, 5);
};
const short = (id) => String(id || '').slice(0, 4) || '????';

function readStdin() {
  try {
    return JSON.parse(fs.readFileSync(0, 'utf8') || '{}');
  } catch {
    return null;
  }
}

function readRecords(dir) {
  let names = [];
  try {
    names = fs.readdirSync(dir).filter((n) => n.endsWith('.json'));
  } catch (err) {
    return err?.code === 'ENOENT' ? [] : [{ file: dir, state: 'UNREADABLE' }];
  }
  const out = [];
  for (const name of names) {
    try {
      out.push({ file: path.join(dir, name), ...JSON.parse(fs.readFileSync(path.join(dir, name), 'utf8')) });
    } catch {
      out.push({ file: path.join(dir, name), state: 'UNREADABLE' });
    }
  }
  return out;
}

function writeRecord(file, record) {
  fs.mkdirSync(path.dirname(file), { recursive: true });
  const tmp = `${file}.${process.pid}.tmp`;
  fs.writeFileSync(tmp, JSON.stringify(record, null, 2) + '\n');
  fs.renameSync(tmp, file);
}

// What the summary may claim about one record — never "stopped" or "free" (D3).
function describe(rec, hasMarker, t) {
  if (rec.state === 'UNREADABLE') return 'UNKNOWN — unreadable record';
  const inTool = rec.in_tool ? ` in ${rec.in_tool.name} since ${hhmm(rec.in_tool.since)}` : '';
  if (rec.state === 'RUNNING') {
    const quiet = t - new Date(rec.last_seen).getTime();
    if (quiet <= STALE_MS) return 'RUNNING'; // an unreadable last_seen falls through to STALE
    return `STALE — possibly unfinished, last seen ${hhmm(rec.last_seen)}${inTool}`;
  }
  // Kept when the same session's next prompt arrived with no Stop / StopFailure — e.g. a user interrupt,
  // which fires no Stop, or a resumed session after a crash (L0.3.1, D1).
  if (rec.state === 'NO_END') return `NO END RECORDED — the same session's next prompt came first, last seen ${hhmm(rec.last_seen)}${inTool}`;
  if (rec.state === 'ENDED') {
    const failed = rec.end === 'failure' ? ` (failed: ${rec.error || 'unknown'})` : '';
    // A writing command holds IN_PROGRESS.md until done: a turn that ended while the marker was present,
    // and the marker is still there, is not a confirmed finish (D4).
    if ((rec.marker_at_end && hasMarker) || rec.end === 'failure') return `ENDED — not confirmed done${failed}`;
    return `ENDED ${hhmm(rec.ended_at)}`;
  }
  return `UNKNOWN — state ${rec.state}`;
}

const needsOwnerWord = (what) => what.startsWith('STALE') || what.startsWith('NO END') || what.includes('not confirmed');

function summary(session, prompt, ownFile) {
  const t = now().getTime();
  const lines = [`LIVE · ${hhmm(now().toISOString())}`];
  let needsOwner = false;
  for (const name of REPOS) {
    const r = repoRoot(name);
    if (!fs.existsSync(r)) {
      lines.push(`${name.padEnd(8)} —  repo not found`);
      continue;
    }
    const hasMarker = fs.existsSync(path.join(r, 'docs', 'status', 'IN_PROGRESS.md'));
    const shown = [];
    for (const rec of readRecords(liveDir(r))) {
      if (rec.file === ownFile) continue; // this session's live file is listed from the new prompt below; kept copies are not skipped
      const what = describe(rec, hasMarker, t);
      if (what.startsWith('ENDED ') && !what.includes('not confirmed')) continue; // plain finished turns stay quiet
      if (needsOwnerWord(what)) needsOwner = true;
      shown.push(`${name.padEnd(8)} ${rec.tool || '?'} ${short(rec.session)}  ${what}  "${rec.command || '?'}" since ${hhmm(rec.started_at)}`);
    }
    if (r === root) {
      shown.unshift(`${name.padEnd(8)} ${TOOL} ${short(session)}  RUNNING  "${prompt}" (this session)`);
    }
    if (hasMarker) shown.push(`${name.padEnd(8)} IN_PROGRESS.md present${shown.length ? '' : ' · no heartbeat'}`);
    if (!shown.length) shown.push(`${name.padEnd(8)} UNKNOWN — no heartbeat (no hook there, or never run) · no IN_PROGRESS.md`); // L0.4 d1: only for a missing file
    lines.push(...shown);
  }
  if (needsOwner) lines.push('Resuming STALE / not-confirmed work needs the owner\'s word.');
  return lines.join('\n');
}

// Removes only what the summary shows as a plain finished turn — never a record it asks the owner about (L0.3.1, D2).
function housekeeping(dir, hasMarker) {
  const t = now().getTime();
  for (const rec of readRecords(dir)) {
    const what = describe(rec, hasMarker, t);
    if (what.startsWith('ENDED ') && !needsOwnerWord(what) && t - new Date(rec.ended_at).getTime() > KEEP_ENDED_MS) {
      try { fs.unlinkSync(rec.file); } catch { /* another session may have removed it */ }
    }
  }
}

function main() {
  const input = readStdin();
  const event = input?.hook_event_name;
  if (!input || !event || !input.session_id) {
    if (event === 'UserPromptSubmit' || !input) process.stdout.write('LIVE · UNKNOWN — monitor error: unreadable hook input\n');
    return;
  }
  const session = input.session_id;
  const file = path.join(liveDir(root), `${TOOL}-${session}.json`);
  const markerNow = () => fs.existsSync(path.join(root, 'docs', 'status', 'IN_PROGRESS.md'));
  const iso = now().toISOString();
  let rec = {};
  try { rec = JSON.parse(fs.readFileSync(file, 'utf8')); } catch { /* first event of this session */ }
  const base = { tool: TOOL, session, command: rec.command || '(started before the hook)', started_at: rec.started_at || iso };

  switch (event) {
    case 'UserPromptSubmit': {
      const prompt = String(input.prompt || '').split('\n')[0].slice(0, 120);
      // 1. Keep this session's previous turn if nothing recorded its end (L0.3.1, D1).
      if (rec.state === 'RUNNING') {
        const stamp = String(rec.started_at || iso).replace(/[^0-9]/g, '').slice(8, 14) || 'unknown';
        writeRecord(path.join(liveDir(root), `${TOOL}-${session}~${stamp}.json`), { ...rec, state: 'NO_END', superseded_at: iso });
      }
      process.stdout.write(summary(session, prompt, file) + '\n'); // 2. read and report (D1)
      process.stdout.write('Card (blueprint v2.0): Type = bare command only · Who acts · Changes · Does = stage ①–⑤ / Setup, then when to type or ⏸ blocked by … · pending actions as rows, never prose\n');
      writeRecord(file, { tool: TOOL, session, command: prompt, started_at: iso, last_seen: iso, in_tool: null, state: 'RUNNING', ended_at: null }); // 3. then write
      housekeeping(liveDir(root), markerNow());
      return;
    }
    case 'PreToolUse':
      writeRecord(file, { ...base, ...rec, last_seen: iso, in_tool: { name: input.tool_name || '?', since: iso }, state: 'RUNNING' });
      return;
    case 'PostToolUse':
    case 'PostToolUseFailure':
      writeRecord(file, { ...base, ...rec, last_seen: iso, in_tool: null, state: 'RUNNING' });
      return;
    case 'Stop':
      if (rec.state === 'ENDED' && rec.end === 'failure') return; // keep the failure if both events fire
      writeRecord(file, { ...base, ...rec, last_seen: iso, in_tool: null, state: 'ENDED', end: 'stop', ended_at: iso, marker_at_end: markerNow() });
      return;
    case 'StopFailure':
      writeRecord(file, { ...base, ...rec, last_seen: iso, in_tool: null, state: 'ENDED', end: 'failure', error: input.error || 'unknown', ended_at: iso, marker_at_end: markerNow() });
      return;
    default:
  }
}

try {
  main();
} catch (err) {
  // Never block a prompt; say so instead of going silent (D5).
  try {
    process.stdout.write(`LIVE · UNKNOWN — monitor error: ${String(err?.message || err).slice(0, 120)}\n`);
  } catch { /* nothing else to do */ }
}
process.exit(0);
