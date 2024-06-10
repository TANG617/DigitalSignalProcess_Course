% Step 1: Extract MFCC features from the dataset
% data_folder = 'music_data_seg';
% file_list = dir(fullfile(data_folder, '*.mp3'));
% mfcc_database = cell(length(file_list), 1);
% 
% for k = 1:length(file_list)
%     file_path = fullfile(data_folder, file_list(k).name);
%     [y, fs] = audioread(file_path);
%     mfcc_database{k} = extract_mfcc(y, fs);
% end

% Step 3: Record new audio and extract its MFCC features
[y_new, fs_new] = record_audio(); % Define your recording function
mfcc_new = extract_mfcc(y_new, fs_new);

% Step 4: Compare the new audio with the dataset using DTW
distances = zeros(length(file_list), 1);
for k = 1:length(file_list)
    distances(k) = dtw(mfcc_new, mfcc_database{k});
end

% Step 5: Find the minimum distance and corresponding song
[~, min_index] = min(distances);
detected_song = file_list(min_index).name;
disp(['Detected song: ', detected_song]);

% Helper functions
function mfcc_features = extract_mfcc(signal, fs)
    % Extract MFCC features from the signal using built-in mfcc function
    window_length = round(0.025 * fs); % 25 ms window
    overlap_length = round(0.01 * fs); % 10 ms overlap
    [coeffs, ~] = mfcc(signal, fs, 'WindowLength', window_length, 'OverlapLength', overlap_length);
    mfcc_features = coeffs;
end

function [audio, fs] = record_audio()
    % Placeholder function to record audio
    % Replace with actual recording code
    fs = 44100; % Sample rate
    duration = 10.0; % Duration in seconds
    recorder = audiorecorder(fs, 16, 1);
    disp('Start speaking.')
    recordblocking(recorder, duration);
    disp('End of Recording.');
    audio = getaudiodata(recorder);
end
