object "CheapProxy" {
    code {
        codecopy(0, dataoffset("runtime"), datasize("runtime"))
        return(0, datasize("runtime"))
    }
    object "runtime" {
        code {
            calldatacopy(0, 0, calldatasize())
            let addr := linkersymbol("proxyImplementation")
            let success := delegatecall(gas(), addr, 0, calldatasize(), 0, 0)
            if success {
                return(0, returndatasize())
            }
            revert(0, returndatasize())
        }
    }
}
