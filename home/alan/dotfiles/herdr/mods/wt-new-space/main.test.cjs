const assert = require('node:assert/strict');
const fs = require('node:fs');
const vm = require('node:vm');

// Exercise the actual picker methods without creating real worktrees.
const source = fs.readFileSync(`${__dirname}/main.js`, 'utf8');
const NewSpace = vm.runInNewContext(
  source.slice(source.indexOf('export default class')).replace('export default ', '') + '\nNewSpace;',
  {
    View: class {},
    repoOf: async () => ({}),
    makeWorktree: async (_repo, _on, _agent, status) => { status('Creating…'); return ''; },
    props: () => ({ overlay: 'test' }),
    closeOverlay: () => {},
  },
);

(async () => {
  const picker = new NewSpace();
  picker.busy = '';
  picker.done = false;
  const jobs = [];
  const cx = { notify() {}, spawn(fn) { jobs.push(fn); } };
  picker.choose({ path: '/test', name: 'test' }, cx);
  picker.choose({ path: '/test', name: 'test' }, cx);
  assert.equal(jobs.length, 1, 'repeated submission must schedule only one worktree');
  await jobs[0](cx);
  assert.equal(picker.done, true);
  assert.equal(picker.busy, '');
  picker.choose({ path: '/test', name: 'test' }, cx);
  assert.equal(jobs.length, 1, 'completed picker must not submit again');
  console.log('PASS: duplicate and post-completion submissions ignored');
})().catch(error => { console.error(error); process.exitCode = 1; });
