import { Client } from 'node-osc';

(async () => {
  const client = new Client('127.0.0.1', 57120);
  const notes = process.argv[2];

  console.log('whistling', notes);
  client.send('/whistle', notes.replace(' ', ''), () => process.exit(0));
})();
