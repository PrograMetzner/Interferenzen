//Idee: kleinen house-track mit Interferenzen als Melodie
//Schritt 1: Hauptklang mit möglichst vielen Interferenzen erstellen:
//
(
{
	var freq = 100;
	//Hauptklang
	var sig = SinOsc.ar(freq) * 2;
	//Interferenzen durch 1. minimale Frequenzunterschiede 2. Phasenunterschiede (3. Lautstärkeunterschiede der einzelnen Flangers)
	var sigFlangeHigh = SinOsc.ar(freq+ SinOsc.ar(0.5).range(1,3),pi / 2) * SinOsc.ar(0.25).range(0.9,1.2);
	var sigFlangeLow = SinOsc.ar(freq - SinOsc.ar(0.025).range(1,2)) * SinOsc.ar(0.3).range(0.8,1.3);
	var sig2 = SinOsc.ar(SinOsc.ar(freq).range(freq + SinOsc.ar(SinOsc.ar(0.225).range(0.01,50)).range(freq - 20, freq + 20)),mul:2);
	Out.ar(0, Splay.ar(sig * sig2 * sigFlangeHigh * sigFlangeLow) * 0.1);
}
).play


//Schritt : durch demand Ugens und Delay "Pattern" erstellen
//Idee: Durch

s.options.memSize = 32*2048;
s.options.numWireBufs = 512;
s.reboot;

(
{
//Sound:
	var freq = Demand.ar(Impulse.ar(0.5),0, Dseq([50, 100, 72,75,50, 100, 72,58],inf));
	var sig = SinOsc.ar(freq) * 2;
//Durch Demand Ugens einen Rhytmhus in den Klang bringen
	var sigFlangeHigh = SinOsc.ar(freq+1) * SinOsc.ar(Demand.ar(Impulse.ar(0.5),0, Dseq([5, 10, 5, 15,5,10,5,10],inf))).range(0.5,1.2);
	var sigFlangeLow = SinOsc.ar(freq - 1) * SinOsc.ar(Demand.ar(Impulse.ar(0.5),0, Dseq([5, 10, 5, 15,5,10,5,10],inf))).range(0.5,1.3);
	var sig2 = SinOsc.ar(SinOsc.ar(freq).range(freq + SinOsc.ar(SinOsc.ar(0.225).range(0.01,50)).range(freq - 20, freq + 20)),pi/2,mul:2);
//Drums:
	var envkick = DelayC.ar(EnvGen.ar(Env.perc(0.0001,0.1),Impulse.ar(2)) * SinOsc.ar(70) * 6,8,8);
	var envOhat = DelayC.ar(EnvGen.ar(Env.perc(0.0001,0.4),Impulse.ar(0.125)) * RHPF.ar(WhiteNoise.ar(),4000) * 0.2,16.75,16.75) * 0.9;
	var envhat = DelayC.ar(EnvGen.ar(Env.perc(0.0001,0.1),Impulse.ar(2)) * RHPF.ar(WhiteNoise.ar(),8000) * 0.2,24.5,24.75) * 3;
	var envhat2 = DelayC.ar(EnvGen.ar(Env.perc(0.0001,0.1),Impulse.ar(0.5)) * RHPF.ar(WhiteNoise.ar(),8005) * 0.2,8.25,8.25) * 4;
	var perc = FreeVerb.ar(DelayC.ar(EnvGen.ar(Env.perc(0.0001,0.15),Impulse.ar(0.125)) * RHPF.ar(WhiteNoise.ar(),600) * 0.2,17.25,17.25)) * 0.75;
	var perc2 = FreeVerb.ar(DelayC.ar(EnvGen.ar(Env.perc(0.00001,0.5),Impulse.ar(0.25)) * BPF.ar(RHPF.ar(WhiteNoise.ar(),200),300) * 0.2,17.75,17.75),0.5,0.3,0.7) * 8;

//Nur der erste Ton klingt percussiv, danach wirds zum Flächenklang. deswegen 4 mal der selbe Synth
	var synth = RLPF.ar(CombC.ar(StkBlowHole.ar(500,64,10.65,60.0),0.5,0.25,10),1000) * Line.ar(8,0,10);
	var synth2 = DelayC.ar(RLPF.ar(CombC.ar(StkBlowHole.ar(500,64,10.65,60.0),0.5,0.25,10),1000) * Line.ar(8,0,10),16,16);
	var synth3 = DelayC.ar(RLPF.ar(CombC.ar(StkBlowHole.ar(500,64,10.65,60.0),0.5,0.25,10),1000) * Line.ar(8,0,10),32,32);
	var synth4 = DelayC.ar(RLPF.ar(CombC.ar(StkBlowHole.ar(500,64,10.65,60.0),0.5,0.25,10),1000) * Line.ar(8,0,10),48,48);

	Out.ar(0, Splay.ar(sig * sig2 * sigFlangeHigh * sigFlangeLow + envkick + envOhat + envhat + envhat2 + perc2 + synth + synth2 + synth3 + synth4) * 0.1);

}.play
)
