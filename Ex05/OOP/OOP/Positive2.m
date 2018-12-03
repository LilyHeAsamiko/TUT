classdef Positive2 < Positive1
    % Positive2 A subclass of Positive1.
    %   Adds the methods double, char and disp.
    
    methods
        %% Constructor
        % The constructor simply calls the superclass constructor.
        function obj = Positive2(varargin)
			obj@Positive1(varargin{:});
        end
        
        %% Convert to double. Doesn't make sense for all classes.
        function x = double(obj)
            x = obj.Value;
        end
        
        %% Convert to string. Many classes are able to convert its
        % objects to some kind of string representation for display.
        function str = char(obj)
            str = num2str(double(obj));
        end
        
        %% Display method calls Matlab's builtin disp function.
        function disp(obj)
			disp(char(obj));
        end
    end
end