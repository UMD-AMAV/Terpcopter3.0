    function angles = EulerAngles( varargin )
% function angles = EulerAngles( q, axes )   or   angles = q.EulerAngles( axes )
% Construct Euler angle triplets equivalent to quaternion rotations
% Inputs:
%  q        quaternion array
%  axes     axes designation strings (e.g. '123' = xyz) or cell strings
%           (e.g. {'123'})
% Output:
%  angles   3 element Euler Angle vectors in radians
        ics     = cellfun( @ischar, varargin );
        if any( ics )
            varargin{ics} = cellstr( varargin{ics} );
        else
            ics = cellfun( @iscellstr, varargin );
        end
        if ~any( ics )
            error( 'Must provide axes as a string (e.g. ''123'') or cell string (e.g. {''123''})' );
        end
        siv     = cellfun( @size, varargin, 'UniformOutput', false );
        axes    = varargin{ics};
        six     = siv{ics};
        nex     = prod( six );
        q       = varargin{~ics};
        siq     = siv{~ics};
        neq     = prod( siq );
        if neq == 1
            siz = six;
            nel = nex;
        elseif nex == 1
            siz = siq;
            nel = neq;
        elseif nex == neq
            siz = siq;
            nel = neq;
        else
            error( 'Must have compatible dimensions for quaternion and axes' );
        end
        angles  = zeros( [3 siz] );
        q       = normalize( q );
        for jel = 1 : nel
            iel = min( jel, neq );
            switch axes{min(jel,nex)}
                
                case {'123', 'xyz', 'XYZ', 'ijk'}
                    angles(1,iel) = atan2(2*(e(2)*e(1)+e(4)*e(3)),(e(1)^2-e(2)^2-e(3)^2+e(4)^2));
                    angles(2,iel) = asin(2*(e(3)*e(1)-e(2)*e(4)));
                    angles(3,iel) = atan2(2*(e(2)*e(3)+ ...
                        e(4)*e(1)),(e(1)^2+ ...
                        e(2)^2-e(3)^2-e(4)^2));
               
                case {'321', 'zyx', 'ZYX', 'kji'}
                    angles(1,iel) = atan2(2*(e(4)*e(1)-e(2)*e(3)),...
                                        (e(1)^2+e(2)^2-e(3)^2-e(4)^2));
                                    
                    angles(2,iel) = asin(2*(e(2)*e(4)+e(3)*e(1)));
                    
                    angles(3,iel) = atan2(2*(e(2)*e(1)-e(3)*e(4)),...
                                         (e(1)^2-e(2)^2-e(3)^2+e(4)^2));
                
                otherwise
                    error( 'Invalid output Euler angle axes' );
            end % switch axes
        end % for iel
        angles  = chop( angles );
    end % EulerAngles