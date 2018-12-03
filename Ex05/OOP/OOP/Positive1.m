classdef Positive1
    % Positive1 Class for positive floating point numbers.
    % A bare bones class with only a constructor.
    
    properties
        Value(1,1) double {mustBePositive} = 1;  % A positive floating point number
    end
    
    methods
        % Constructor. Constructs a new Positive1 object.
        % The argument must be a positive floating point number.
        % If no argument is given, the default value of 1 is used.
        function obj = Positive1(x)
            narginchk(0, 1);
            if nargin == 1
                obj.Value = x;
            end
        end
    end
end