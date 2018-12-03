classdef Positive < PositiveL & PositiveA
    % Positive A subclass of PositiveL and PositiveA
    %   This class has both relational and algebraic operations.
    
    methods
        %% Constructor
        % The constructor simply calls the superclass constructor.
        function obj = Positive(varargin)
			obj@PositiveL(varargin{:});
			obj@PositiveA(varargin{:});
        end
    end
    
end