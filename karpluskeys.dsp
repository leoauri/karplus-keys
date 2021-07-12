declare name "Karplus Keys";

declare options "[midi:on]";
declare options "[nvoices:32]";


import("stdfaust.lib");
import("delays.lib");
import("maths.lib");
import("filters.lib");
import("envelopes.lib");



lowest_delay = ma.SR / 27.5;

freq = vslider("freq[style:knob]", 27.5, 27.5, 4186.01, 0.01);
gain = vslider("gain[style:knob]", 0, 0, 1, 0.01);
gate = button("gate");

delay_samples = ma.SR / freq;

onset(x) = (x-x') > 0;
decay(n,x) = x - (x>0)/n;
release(n) = + ~ decay(n);
hold(n) = onset : release(n) : >(0.0);


env = en.asr(hslider("attack[style:knob]", 0, 0, 1, 0.01), 1, hslider("release[style:knob]", 0, 0, 6, 0.01), gate);

ring = (+ : de.delay(lowest_delay, delay_samples) * (env > 0)) ~ (fi.fir((0.5,0.5)));


process = _ : *(gate : hold(delay_samples)) : ring * env * gain <: _,_;