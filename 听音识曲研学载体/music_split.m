% split_audio.m
% This script splits all mp3 files in the data_set folder into 10s segments with 5s overlap

% Define parameters
segment_duration = 10; % duration of each segment in seconds
overlap_duration = 5; % overlap duration in seconds

% Create output directory if it does not exist
output_folder = 'music_data_seg';
if ~exist(output_folder, 'dir')
    mkdir(output_folder);
end

% Get list of all mp3 files in the data_set directory
data_folder = 'music_data';
file_list = dir(fullfile(data_folder, '*.mp3'));

% Process each file
for k = 1:length(file_list)
    file_path = fullfile(data_folder, file_list(k).name);
    [y, fs] = audioread(file_path);
    segments = split_audio(y, fs, segment_duration, overlap_duration);
    
    % Save each segment as a new file
    for seg = 1:length(segments)
        segment_file_name = sprintf('%s_seg_%02d.mp3', file_list(k).name(1:end-4), seg);
        output_path = fullfile(output_folder, segment_file_name);
        audiowrite(output_path, segments{seg}, fs);
    end
end

disp('Audio splitting complete.');

function segments = split_audio(signal, fs, segment_duration, overlap_duration)
    % Split audio into segments with overlap
    segment_samples = segment_duration * fs;
    overlap_samples = overlap_duration * fs;
    step_samples = segment_samples - overlap_samples;
    num_segments = ceil((length(signal) - overlap_samples) / step_samples);

    segments = cell(num_segments, 1);
    for i = 1:num_segments
        start_idx = (i-1) * step_samples + 1;
        end_idx = min(start_idx + segment_samples - 1, length(signal));
        segments{i} = signal(start_idx:end_idx);
    end
end