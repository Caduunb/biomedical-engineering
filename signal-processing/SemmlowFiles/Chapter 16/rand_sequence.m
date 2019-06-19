function rand_seq = rand_sequence(number, max_index)
%  Function to generate a random sequence of 'number'
%    numbers ranging between 1 and max value.  The sequence should be 
%    free of repeat values
%
j = 1;
rand_seq(1) = round(rand*(max_index-1)) + 1;  % Get first trial numbers
while (1)       % Loop forever
    rand_num = round(rand*(max_index-1)) + 1;      %Get trial numbers
    dup_flag = 'n';     % Initialize duplicate flag
    for i = 1:length(rand_num) % Check if duplicate
       if rand_num == rand_seq(i)
            dup_flag == 'y';    % Duplicate found
       end
    end
    if dup_flag == 'n'
       rand_seq(j) = rand_num; % Save randum number
       j = j + 1;
    end
    if j == number
       break;  % Done, exit loop
    end
end
    