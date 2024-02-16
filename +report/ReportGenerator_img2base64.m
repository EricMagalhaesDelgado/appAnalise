function [imgExt, imgString] = ReportGenerator_img2base64(imgFullPath)

    fileID = fopen(imgFullPath, 'r');
    while fileID == -1
        pause(1)
        fileID = fopen(imgFullPath, 'r');
    end
    
    [~,~,imgExt] = fileparts(imgFullPath);
    switch lower(imgExt)
        case '.png';            imgExt = 'png';
        case {'.jpg', '.jpeg'}; imgExt = 'jpeg';
        case '.gif';            imgExt = 'gif';
        case '.svg';            imgExt = 'svg+xml';
        otherwise;              error('Image file format must be "JPEG", "PNG", "GIF", or "SVG".')
    end
    
    imgArray  = fread(fileID, 'uint8=>uint8');
    imgString = matlab.net.base64encode(imgArray);
    fclose(fileID);

end