import Metal

internal var isMetalAvailable: Bool {
    get {
        #if (arch(i386) || arch(x86_64))
        // シミュレータは false
        return false
        #else
        // 実機での判別
        if #available(iOS 9.0, *) {
            if let _ = MTLCreateSystemDefaultDevice() {
                return true
            } else {
                return false
            }
        } else {
            // iOS 8 は Metal 自体はあるけど MTKView はないので false
            return false
        }
        #endif
    }
}
