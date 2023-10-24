public class ForeignClassType: BaseType, LayoutType {
    private(set) var layout: UnsafeMutablePointer<BaseLayout>!
    override func build() {
        super.build()
        layout = builtLayout()
    }
}