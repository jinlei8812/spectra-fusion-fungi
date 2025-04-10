% Define the true classes and predicted classes
trueLabels = [repmat({'C_glabrata'}, 14, 1); ...
              repmat({'C_albicans'}, 13, 1); ...
              repmat({'C_tropicalis'}, 3, 1); ...
              repmat({'A_flavus'}, 3, 1); ...
              repmat({'Penicillium'}, 2, 1); ...
              repmat({'Fusarium'}, 2, 1); ...
              repmat({'A_terreus'}, 1, 1)];

% Predicted labels (one C. glabrata misidentified but still identified as some other species)
predictedLabels = [repmat({'C_glabrata'}, 13, 1); {'Other'}; ...
                   repmat({'C_albicans'}, 13, 1); ...
                   repmat({'C_tropicalis'}, 3, 1); ...
                   repmat({'A_flavus'}, 3, 1); ...
                   repmat({'Penicillium'}, 2, 1); ...
                   repmat({'Fusarium'}, 2, 1); ...
                   repmat({'A_terreus'}, 1, 1)];

% Define unique categories, replacing invalid characters with underscores
categories = {'C_glabrata', 'C_albicans', 'C_tropicalis', ...
              'A_flavus', 'Penicillium', 'Fusarium', 'A_terreus', 'Other'};

% Generate the confusion matrix
confMat = confusionmat(trueLabels, predictedLabels, 'Order', categories);

% Calculate total samples and identification accuracy
totalSamples = sum(confMat, 'all');  % Total number of samples
correctIdentifications = sum(diag(confMat)); % Correct identifications (diagonal of the matrix)
overallAccuracy = (correctIdentifications / totalSamples) * 100;

% Calculate accuracy for each species
speciesAccuracy = diag(confMat) ./ sum(confMat, 2) * 100;

% Create a new figure for the heatmap
figure;
h = heatmap(categories, categories, confMat, ...
        'Title', ['Confusion Matrix for Fungal Identification (Overall Accuracy: ', num2str(overallAccuracy, '%.2f'), '%)'], ...
        'XLabel', 'Predicted Classes', ...
        'YLabel', 'True Classes', ...
        'Colormap', pink);

% Remove the colorbar
h.ColorbarVisible = 'on';

% Overlay species accuracy on the diagonal
% Get axes position for precise text placement
ax = gca; % Get current axes
pos = ax.Position; % Position of the heatmap
xStart = pos(1);
yStart = pos(2);
width = pos(3);
height = pos(4);

% Calculate step size based on the number of categories
xStep = width / length(categories);
yStep = height / length(categories);

% Add annotations for diagonal accuracy
for i = 1:length(categories)
    xPos = xStart + (i - 0.5) * xStep;
    yPos = yStart + (length(categories) - i + 0.5) * yStep;
    annotation('textbox', [xPos, yPos, 0.05, 0.05], ...
        'String', sprintf('%.2f%%', speciesAccuracy(i)), ...
        'HorizontalAlignment', 'center', ...
        'VerticalAlignment', 'middle', ...
        'EdgeColor', 'none', ...
        'FontSize', 10, ...
        'Color', 'red', ...
        'FontWeight', 'bold');
end

% Display the confusion matrix in the MATLAB Command Window
disp('Confusion matrix:');
disp(array2table(confMat, 'VariableNames', categories, 'RowNames', categories));

% Display species-wise accuracy in the Command Window
disp('Identification accuracy for each species:');
for i = 1:length(categories)
    fprintf('%s: %.2f%%\n', categories{i}, speciesAccuracy(i));
end
