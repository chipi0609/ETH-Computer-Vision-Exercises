% Convert to L*a*b space

function imgLab = conver2lab(img)
    cform = makecform('srgb2lab');
    imgLab = applycform(img,cform);
end