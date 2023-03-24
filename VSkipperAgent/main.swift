//  Created by p0ch1ta on 18/03/2023 for project VSkipper

import Foundation

let agentState = AgentState()
let server = Server(agentState: agentState)

let loop = CFRunLoopGetCurrent()
server.addSourceForNewLocalMessagePort(name: "io.yokata.VSkipperAgent", toRunLoop: loop)

let timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { timer in
    agentState.checkForSkip()
}
RunLoop.current.add(timer, forMode: .common)

CFRunLoopRun()

