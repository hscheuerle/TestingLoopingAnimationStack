import SwiftUI

// ! Scale instead of changing font, in order to interpolate, and to set anchor
enum PositionState {
    case first
    case second
    case third
    case reset
    var nextState: Self {
        switch self {
        case .first: return .second
        case .second: return .third
        case .third: return .reset
        case .reset: return .first
        }
    }
    var previousState: Self {
        switch self {
        case .first: return .reset
        case .second: return .first
        case .third: return .second
        case .reset: return .third
        }
    }
    // will have to undo this to consume geometry reader
    var stateView: some View {
        switch self {
        case .first:
            return Text("20")
                .font(.system(size: 48))
                .scaleEffect(1)
                .animation(.default)
                .offset(x: 0, y: 0)
                .animation(.default)
                .opacity(1.0)
                .animation(.default)
        case .second:
            return Text("20")
                .font(.system(size: 48))
                .scaleEffect(0.7)
                .animation(.default)
                .offset(x: -60, y: 0)
                .animation(.default)
                .opacity(1.0)
                .animation(.default)
        case .third:
            return Text("20")
                .font(.system(size: 48))
                .scaleEffect(0.4)
                .animation(.default)
                .offset(x: -120, y: 0)
                .animation(.default)
                .opacity(0.0)
                .animation(.default)
        case .reset:
            return Text("20")
                .font(.system(size: 48))
                .scaleEffect(1)
                .animation(nil)
                .offset(x: 0, y: 0)
                .animation(nil)
                .opacity(0.0)
                .animation(nil)
        }
    }
}

struct GeometryReporter: View {
    @Binding var binding: CGSize
    var body: some View {
        GeometryReader { geo in
            Color.clear
                .onAppear { binding = geo.size }
                .onChange(of: geo.size) { binding = $0 }
        }
    }
}

extension View {
    func reportingSize(to binding: Binding<CGSize>) -> some View {
        self.background(GeometryReporter(binding: binding))
    }
}

struct ContentView: View {
    @State var positionState: PositionState = .first
    @State var positionStateTwo: PositionState = .second
    @State var positionStateThree: PositionState = .third
    @State var positionStateReset: PositionState = .reset

    
    @State var sizeOne: CGSize = .zero

    var body: some View {
        VStack {
            ZStack {
                positionState
                    .stateView
                
                positionStateTwo
                    .stateView
                
                positionStateThree
                    .stateView
                
                positionStateReset
                    .stateView

            }
            Spacer()
            Text("Next").onTapGesture {
                positionState = positionState.nextState
                positionStateTwo = positionStateTwo.nextState
                positionStateThree = positionStateThree.nextState
                positionStateReset = positionStateReset.nextState
            }
            Text("Prev").onTapGesture {
                positionState = positionState.previousState
                positionStateTwo = positionStateTwo.previousState
                positionStateThree = positionStateThree.previousState
                positionStateReset = positionStateReset.previousState
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
