public class ProtocolType: BaseType, LayoutType {
    private(set) var layout: UnsafeMutablePointer<ProtocolLayout>!
    override func build() {
        super.build()
        layout = builtLayout()
    }
}