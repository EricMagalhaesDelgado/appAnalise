% CompressLib.m
%--------------------------------------------------------------------------
% This Matlab class contains only static methods. These methods will 
% compress matlab variables in java GZIP functions. Matrices, strings, 
% structures, and cell arrays are supported. 
%
% Original Author: Jesse Hopkins
% Date: 2009/10/29
% Version: 1.5
%
% Co-Author: Patrik Forssén
% Date: 2022/10/16
% Source:
% https://www.mathworks.com/matlabcentral/fileexchange/25656-compression-routines
% (Discussion tab)
%--------------------------------------------------------------------------

classdef CompressLib

	methods(Static = true)

		function out = decompress(byteArray)

			import com.mathworks.mlwidgets.io.InterruptibleStreamCopier

			if ~strcmpi(class(byteArray), 'uint8') || ndims(byteArray) > 2 || min(size(byteArray) ~= 1)
				error('Input must be a 1-D array of uint8');
			end

			a = java.io.ByteArrayInputStream(byteArray);
			b = java.util.zip.GZIPInputStream(a);
            
            isc = InterruptibleStreamCopier.getInterruptibleStreamCopier;
			c = java.io.ByteArrayOutputStream;
			
            isc.copyStream(b,c);
			byteData = typecast(c.toByteArray, 'uint8');

			% Decompressed byte array >> Matlab data type
            out = getArrayFromByteStream(byteData);

		end


		function byteArray = compress(in)

			% Input variable >> array of bytes
            byteData = getByteStreamFromArray(in);

			f = java.io.ByteArrayOutputStream();
			g = java.util.zip.GZIPOutputStream(f);

			g.write(byteData);
			g.close;

			byteArray = typecast(f.toByteArray, 'uint8');
			f.close;

        end
    end

end