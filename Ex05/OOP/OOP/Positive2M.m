classdef Positive2M < Positive2
    % PositiveBA A subclass of PositiveBD.
    %   Redefines the method double to work with arrays.
    %   Also redefines the constructor to allow construction from an array.
    
    methods
        %% Constructor
        function obj = Positive2M(x)
            if nargin == 1
                if isscalar(x)
                    % Construct from a floating point number
                    obj.Value = x;
                else
                    % Construct from a floating point array
                    n = numel(x);
                    obj(n) = x(n); % Allocate the result as a vector
                    % Copy the elemnts of x into obj
                    for k = 1:n-1
                        obj(k).Value = x(k);
                    end
                    % Reshape to the correct size
                    obj = reshape(obj, size(x));
                end
            end
        end
        
        %% We redefine double to work with arrays
        % First extract the Value fields into a vector with [obj.Value] and then
        % reshape that into an array of the correct size.
        function x = double(obj)
            x = reshape([obj.Value], size(obj));
        end
    end
end