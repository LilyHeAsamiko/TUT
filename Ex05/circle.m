classdef circle
    properties
        Radius(1,1) double {mustBePositive} = 1;  % A positive floating point number
        Center(1,2) double = [0 0];
    end
    methods
        % Constructor. Constructs a new Positive1 object.
        % The argument must be a positive floating point number.
        % If no argument is given, the default value of 1 is used.
        function obj = circle(c,r)
            narginchk(0, 2);
            if nargin == 1
                obj.Center = c;
            elseif nargin == 2
                obj.Center = c;
                obj.Radius = r;
            end
        end
        
        function plot(obj, varargin)
            pos = [obj.Center(1)-obj.Radius obj.Center(2)-obj.Radius...
                2*obj.Radius 2*obj.Radius];
            rectangle ('Position', pos, 'Curvature', [1 1], varargin{:})
            axis equal
        end
        
        function h = plus(obj1, obj2)
            C = obj1.Center + obj2.Center;
            R = obj1.Radius + obj2.Radius;
            h = circle(C, R);
        end
    end
end