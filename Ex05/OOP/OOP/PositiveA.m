classdef PositiveA < Positive2M
    % PositiveA A subclass of Positive2M
    %   Adds algebraic operations
    
    methods
        %% Constructor
        % The constructor simply calls the superclass constructor.
        function obj = PositiveA(varargin)
			obj@Positive2M(varargin{:});
        end
        
        %% The algebraic operations.
        % Addition: obj1 + obj2
        function res = plus(obj1, obj2)
            res = PositiveA(obj1.Value + obj2.Value);
        end
        
        % Elementwise multiplication: obj1 .* obj2
        function res = times(obj1, obj2)
            res = PositiveA(obj1.Value .* obj2.Value);
        end
        
        % Matrix multiplication: obj1 * obj2
        function res = mtimes(obj1, obj2)
            res = PositiveA(obj1.Value * obj2.Value);
        end
        
        % Elementwise right division: obj1 ./ obj2
        function res = rdivide(obj1, obj2)
            res = PositiveA(obj1.Value ./ obj2.Value);
        end
        
        % Elementwise left division: obj1 .\ obj2
        function res = ldivide(obj1, obj2)
            res = PositiveA(obj1.Value .\ obj2.Value);
        end
        
        % Matrix right division: obj1 / obj2
        function res = mrdivide(obj1, obj2)
            res = PositiveA(obj1.Value / obj2.Value);
        end
        
        % Matrix left division: obj1 \ obj2
        function res = mldivide(obj1, obj2)
            res = PositiveA(obj1.Value \ obj2.Value);
        end
        
        % Elementwise power: obj1 .^ obj2
        function res = power(obj1, obj2)
            res = PositiveA(obj1.Value .^ obj2.Value);
        end
        
        % Matrix power: obj1 ^ obj2
        function res = mpower(obj1, obj2)
            res = PositiveA(obj1.Value ^ obj2.Value);
        end
        
        % Unary plus: +obj
        function res = uplus(obj)
            res = obj;
        end
    end
end