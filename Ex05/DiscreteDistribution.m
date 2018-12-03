classdef DiscreteDistribution
    properties
        p(1,:) double {mustBeNonnegative, mustBeLessThanOrEqual(p,1),...
            mustSumTo1(p)} = 1; 
        psums(1,:) double;
    end
    methods
        % Constructor. Constructs a new Positive1 object.
        % The argument must be a positive floating point number.
        % If no argument is given, the default value of 1 is used.
        function obj = DiscreteDistribution(prob)
            narginchk(0, 1);
            if nargin == 1
                obj.p = prob;
                obj.psums = cumsum(prob);
            end
        end
        
        function A = random(obj, varargin)
            A = zeros(varargin{:});
            for k = 1:numel(A)
                u = rand;
                A(k) = find(u < obj.psums,1);
            end
        end 
    end
end

function mustSumTo1(p)
    assert(abs(sum(p)-1) < length(p)*eps,'The probabilities must sum to 1.');
end
