function [audio, fs] = record_audio()
    % Placeholder function to record audio
    % Replace with actual recording code
    fs = 44100; % Sample rate
    duration = 10; % Duration in seconds
    recorder = audiorecorder(fs, 16, 1);
    disp('Start speaking.')
    recordblocking(recorder, duration);
    disp('End of Recording.');
    audio = getaudiodata(recorder);
end


[y_new, fs_new] = record_audio(); % Define your recording function
mfcc_new = extract_mfcc(y_new, fs_new);

