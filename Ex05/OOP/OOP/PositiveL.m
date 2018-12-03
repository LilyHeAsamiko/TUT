classdef PositiveL < Positive2M
    % PositiveL A subclass of Positive2M
    %   Adds relational operations
    
    methods
        %% Constructor
        % The constructor simply calls the superclass constructor.
        function obj = PositiveL(varargin)
			obj@Positive2M(varargin{:});
        end
        
        %% The relational operations == and <.
        % Test if obj1 == obj2
        function bool = eq(obj1, obj2)
            bool = (obj1.Value == obj2.Value);
        end
        
        % Test if obj1 < obj2
        function bool = lt(obj1, obj2)
            bool = (obj1.Value < obj2.Value);
        end
        
        %% The rest of the relational operations are defined in terms of == and <.
        % Test if obj1 ~= obj2
        function bool = ne(obj1, obj2)
            bool = ~(obj1 == obj2);
        end
        
        % Test if obj1 > obj2
        function bool = gt(obj1, obj2)
            bool = (obj2 < obj1);
        end
        
        % Test if obj1 <= obj2
        function bool = le(obj1, obj2)
            bool = (obj1 < obj2) | (obj1 == obj2);
        end
        
        % Test if obj1 >= obj2
        function bool = ge(obj1, obj2)
            bool = (obj2 <= obj1);
        end
    end
end