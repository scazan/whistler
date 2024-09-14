
(
s.waitForBoot({
	OSCdef(\whistle, { | msg |

		var notes = msg[1].asString().split($,);
		var durations = [1,0.5,0.75, 0.25, 1];
		notes.postln;

		s.waitForBoot({
			var octave = 7.5;
			var noteMappings = Dictionary.with(*[
				'g#'-> -4,'a'-> -3, 'a#'-> -2,'b'-> -1,
				'c'->0, 'c#'->1, 'd'->2, 'd#'->3, 'e' ->4, 'f'->5, 'f#'->6, 'g'->7,
			]);

			SynthDef(\whistle, {
				arg out=0, pan=0, freq=440, endFreq=440, dur=1, amp=2.0, atk=0.0001, rel=0.1;
				var sus, env;

				sus = dur - atk - rel;
				env = EnvGen.ar(Env.linen(atk, sus, rel), doneAction:2);

				Out.ar([0,1], BPF.ar(GrayNoise.ar(), XLine.kr(freq, endFreq, 0.2).lag(dur*0.1) + SinOsc.ar(6, mul: 5), 0.0001) * 8 * env);
			}).add;
			s.sync;

			r = Routine.new({
				var durationSeq = Prand(durations, inf).asStream;
				var randomBreathIndex = 4.rand + 3;
				notes.do({|noteString, i|
					var note = noteString.asSymbol();
					var dur = durationSeq.next * 3;
					var midiNote = noteMappings.at(note) + (octave * 12);
					var previousNote = if(i == 0, midiNote, { noteMappings.at(notes[i-1].asSymbol()) + (octave * 12) });
					var shouldTakeBreath = i != 0 && (i % randomBreathIndex) == 0;
					var release = if(shouldTakeBreath, 0.8, 0.1);
					var synth = Synth.new(\whistle, [\freq, previousNote.midicps, \endFreq, midiNote.midicps, \dur, dur, \rel, release]);

					dur.wait;

					if (shouldTakeBreath || (i == notes.size), {
						// take a breath
						0.5.wait;
					});
				});



			});
			r.play;
		});

	}, '/whistle');
});
)
