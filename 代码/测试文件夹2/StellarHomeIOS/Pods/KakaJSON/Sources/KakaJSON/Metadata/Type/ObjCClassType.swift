public class ObjCClassType: BaseType, LayoutType {
    private(set) var layout: UnsafeMutablePointer<BaseLayout>!
    override func build() {
        super.build()
        layout = builtLayout()
    }
}