
scale([10,10,5]) {
    linear_extrude(height = 0.14) { 
        import("/home/pascal/Dropbox/3d-printing/004-lamp-dimmer/1-layer-1b.dxf"); 
    }

    linear_extrude(height = 0.32) { 
        import("/home/pascal/Dropbox/3d-printing/004-lamp-dimmer/1-layer-2.dxf"); 
    }

    linear_extrude(height = 0.55) { 
        import("/home/pascal/Dropbox/3d-printing/004-lamp-dimmer/1-layer-3.dxf"); 
    }
}