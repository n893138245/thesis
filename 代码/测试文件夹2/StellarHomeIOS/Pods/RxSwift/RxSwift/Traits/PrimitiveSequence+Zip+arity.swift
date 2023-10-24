extension PrimitiveSequenceType where Trait == SingleTrait {
    public static func zip<E1, E2>(_ source1: PrimitiveSequence<Trait, E1>, _ source2: PrimitiveSequence<Trait, E2>, resultSelector: @escaping (E1, E2) throws -> Element)
        -> PrimitiveSequence<Trait, Element> {
            return PrimitiveSequence(raw: Observable.zip(
            source1.asObservable(), source2.asObservable(),
                resultSelector: resultSelector)
            )
    }
}
extension PrimitiveSequenceType where Element == Any, Trait == SingleTrait {
    public static func zip<E1, E2>(_ source1: PrimitiveSequence<Trait, E1>, _ source2: PrimitiveSequence<Trait, E2>)
        -> PrimitiveSequence<Trait, (E1, E2)> {
        return PrimitiveSequence(raw: Observable.zip(
                source1.asObservable(), source2.asObservable())
            )
    }
}
extension PrimitiveSequenceType where Trait == MaybeTrait {
    public static func zip<E1, E2>(_ source1: PrimitiveSequence<Trait, E1>, _ source2: PrimitiveSequence<Trait, E2>, resultSelector: @escaping (E1, E2) throws -> Element)
        -> PrimitiveSequence<Trait, Element> {
            return PrimitiveSequence(raw: Observable.zip(
            source1.asObservable(), source2.asObservable(),
                resultSelector: resultSelector)
            )
    }
}
extension PrimitiveSequenceType where Element == Any, Trait == MaybeTrait {
    public static func zip<E1, E2>(_ source1: PrimitiveSequence<Trait, E1>, _ source2: PrimitiveSequence<Trait, E2>)
        -> PrimitiveSequence<Trait, (E1, E2)> {
        return PrimitiveSequence(raw: Observable.zip(
                source1.asObservable(), source2.asObservable())
            )
    }
}
extension PrimitiveSequenceType where Trait == SingleTrait {
    public static func zip<E1, E2, E3>(_ source1: PrimitiveSequence<Trait, E1>, _ source2: PrimitiveSequence<Trait, E2>, _ source3: PrimitiveSequence<Trait, E3>, resultSelector: @escaping (E1, E2, E3) throws -> Element)
        -> PrimitiveSequence<Trait, Element> {
            return PrimitiveSequence(raw: Observable.zip(
            source1.asObservable(), source2.asObservable(), source3.asObservable(),
                resultSelector: resultSelector)
            )
    }
}
extension PrimitiveSequenceType where Element == Any, Trait == SingleTrait {
    public static func zip<E1, E2, E3>(_ source1: PrimitiveSequence<Trait, E1>, _ source2: PrimitiveSequence<Trait, E2>, _ source3: PrimitiveSequence<Trait, E3>)
        -> PrimitiveSequence<Trait, (E1, E2, E3)> {
        return PrimitiveSequence(raw: Observable.zip(
                source1.asObservable(), source2.asObservable(), source3.asObservable())
            )
    }
}
extension PrimitiveSequenceType where Trait == MaybeTrait {
    public static func zip<E1, E2, E3>(_ source1: PrimitiveSequence<Trait, E1>, _ source2: PrimitiveSequence<Trait, E2>, _ source3: PrimitiveSequence<Trait, E3>, resultSelector: @escaping (E1, E2, E3) throws -> Element)
        -> PrimitiveSequence<Trait, Element> {
            return PrimitiveSequence(raw: Observable.zip(
            source1.asObservable(), source2.asObservable(), source3.asObservable(),
                resultSelector: resultSelector)
            )
    }
}
extension PrimitiveSequenceType where Element == Any, Trait == MaybeTrait {
    public static func zip<E1, E2, E3>(_ source1: PrimitiveSequence<Trait, E1>, _ source2: PrimitiveSequence<Trait, E2>, _ source3: PrimitiveSequence<Trait, E3>)
        -> PrimitiveSequence<Trait, (E1, E2, E3)> {
        return PrimitiveSequence(raw: Observable.zip(
                source1.asObservable(), source2.asObservable(), source3.asObservable())
            )
    }
}
extension PrimitiveSequenceType where Trait == SingleTrait {
    public static func zip<E1, E2, E3, E4>(_ source1: PrimitiveSequence<Trait, E1>, _ source2: PrimitiveSequence<Trait, E2>, _ source3: PrimitiveSequence<Trait, E3>, _ source4: PrimitiveSequence<Trait, E4>, resultSelector: @escaping (E1, E2, E3, E4) throws -> Element)
        -> PrimitiveSequence<Trait, Element> {
            return PrimitiveSequence(raw: Observable.zip(
            source1.asObservable(), source2.asObservable(), source3.asObservable(), source4.asObservable(),
                resultSelector: resultSelector)
            )
    }
}
extension PrimitiveSequenceType where Element == Any, Trait == SingleTrait {
    public static func zip<E1, E2, E3, E4>(_ source1: PrimitiveSequence<Trait, E1>, _ source2: PrimitiveSequence<Trait, E2>, _ source3: PrimitiveSequence<Trait, E3>, _ source4: PrimitiveSequence<Trait, E4>)
        -> PrimitiveSequence<Trait, (E1, E2, E3, E4)> {
        return PrimitiveSequence(raw: Observable.zip(
                source1.asObservable(), source2.asObservable(), source3.asObservable(), source4.asObservable())
            )
    }
}
extension PrimitiveSequenceType where Trait == MaybeTrait {
    public static func zip<E1, E2, E3, E4>(_ source1: PrimitiveSequence<Trait, E1>, _ source2: PrimitiveSequence<Trait, E2>, _ source3: PrimitiveSequence<Trait, E3>, _ source4: PrimitiveSequence<Trait, E4>, resultSelector: @escaping (E1, E2, E3, E4) throws -> Element)
        -> PrimitiveSequence<Trait, Element> {
            return PrimitiveSequence(raw: Observable.zip(
            source1.asObservable(), source2.asObservable(), source3.asObservable(), source4.asObservable(),
                resultSelector: resultSelector)
            )
    }
}
extension PrimitiveSequenceType where Element == Any, Trait == MaybeTrait {
    public static func zip<E1, E2, E3, E4>(_ source1: PrimitiveSequence<Trait, E1>, _ source2: PrimitiveSequence<Trait, E2>, _ source3: PrimitiveSequence<Trait, E3>, _ source4: PrimitiveSequence<Trait, E4>)
        -> PrimitiveSequence<Trait, (E1, E2, E3, E4)> {
        return PrimitiveSequence(raw: Observable.zip(
                source1.asObservable(), source2.asObservable(), source3.asObservable(), source4.asObservable())
            )
    }
}
extension PrimitiveSequenceType where Trait == SingleTrait {
    public static func zip<E1, E2, E3, E4, E5>(_ source1: PrimitiveSequence<Trait, E1>, _ source2: PrimitiveSequence<Trait, E2>, _ source3: PrimitiveSequence<Trait, E3>, _ source4: PrimitiveSequence<Trait, E4>, _ source5: PrimitiveSequence<Trait, E5>, resultSelector: @escaping (E1, E2, E3, E4, E5) throws -> Element)
        -> PrimitiveSequence<Trait, Element> {
            return PrimitiveSequence(raw: Observable.zip(
            source1.asObservable(), source2.asObservable(), source3.asObservable(), source4.asObservable(), source5.asObservable(),
                resultSelector: resultSelector)
            )
    }
}
extension PrimitiveSequenceType where Element == Any, Trait == SingleTrait {
    public static func zip<E1, E2, E3, E4, E5>(_ source1: PrimitiveSequence<Trait, E1>, _ source2: PrimitiveSequence<Trait, E2>, _ source3: PrimitiveSequence<Trait, E3>, _ source4: PrimitiveSequence<Trait, E4>, _ source5: PrimitiveSequence<Trait, E5>)
        -> PrimitiveSequence<Trait, (E1, E2, E3, E4, E5)> {
        return PrimitiveSequence(raw: Observable.zip(
                source1.asObservable(), source2.asObservable(), source3.asObservable(), source4.asObservable(), source5.asObservable())
            )
    }
}
extension PrimitiveSequenceType where Trait == MaybeTrait {
    public static func zip<E1, E2, E3, E4, E5>(_ source1: PrimitiveSequence<Trait, E1>, _ source2: PrimitiveSequence<Trait, E2>, _ source3: PrimitiveSequence<Trait, E3>, _ source4: PrimitiveSequence<Trait, E4>, _ source5: PrimitiveSequence<Trait, E5>, resultSelector: @escaping (E1, E2, E3, E4, E5) throws -> Element)
        -> PrimitiveSequence<Trait, Element> {
            return PrimitiveSequence(raw: Observable.zip(
            source1.asObservable(), source2.asObservable(), source3.asObservable(), source4.asObservable(), source5.asObservable(),
                resultSelector: resultSelector)
            )
    }
}
extension PrimitiveSequenceType where Element == Any, Trait == MaybeTrait {
    public static func zip<E1, E2, E3, E4, E5>(_ source1: PrimitiveSequence<Trait, E1>, _ source2: PrimitiveSequence<Trait, E2>, _ source3: PrimitiveSequence<Trait, E3>, _ source4: PrimitiveSequence<Trait, E4>, _ source5: PrimitiveSequence<Trait, E5>)
        -> PrimitiveSequence<Trait, (E1, E2, E3, E4, E5)> {
        return PrimitiveSequence(raw: Observable.zip(
                source1.asObservable(), source2.asObservable(), source3.asObservable(), source4.asObservable(), source5.asObservable())
            )
    }
}
extension PrimitiveSequenceType where Trait == SingleTrait {
    public static func zip<E1, E2, E3, E4, E5, E6>(_ source1: PrimitiveSequence<Trait, E1>, _ source2: PrimitiveSequence<Trait, E2>, _ source3: PrimitiveSequence<Trait, E3>, _ source4: PrimitiveSequence<Trait, E4>, _ source5: PrimitiveSequence<Trait, E5>, _ source6: PrimitiveSequence<Trait, E6>, resultSelector: @escaping (E1, E2, E3, E4, E5, E6) throws -> Element)
        -> PrimitiveSequence<Trait, Element> {
            return PrimitiveSequence(raw: Observable.zip(
            source1.asObservable(), source2.asObservable(), source3.asObservable(), source4.asObservable(), source5.asObservable(), source6.asObservable(),
                resultSelector: resultSelector)
            )
    }
}
extension PrimitiveSequenceType where Element == Any, Trait == SingleTrait {
    public static func zip<E1, E2, E3, E4, E5, E6>(_ source1: PrimitiveSequence<Trait, E1>, _ source2: PrimitiveSequence<Trait, E2>, _ source3: PrimitiveSequence<Trait, E3>, _ source4: PrimitiveSequence<Trait, E4>, _ source5: PrimitiveSequence<Trait, E5>, _ source6: PrimitiveSequence<Trait, E6>)
        -> PrimitiveSequence<Trait, (E1, E2, E3, E4, E5, E6)> {
        return PrimitiveSequence(raw: Observable.zip(
                source1.asObservable(), source2.asObservable(), source3.asObservable(), source4.asObservable(), source5.asObservable(), source6.asObservable())
            )
    }
}
extension PrimitiveSequenceType where Trait == MaybeTrait {
    public static func zip<E1, E2, E3, E4, E5, E6>(_ source1: PrimitiveSequence<Trait, E1>, _ source2: PrimitiveSequence<Trait, E2>, _ source3: PrimitiveSequence<Trait, E3>, _ source4: PrimitiveSequence<Trait, E4>, _ source5: PrimitiveSequence<Trait, E5>, _ source6: PrimitiveSequence<Trait, E6>, resultSelector: @escaping (E1, E2, E3, E4, E5, E6) throws -> Element)
        -> PrimitiveSequence<Trait, Element> {
            return PrimitiveSequence(raw: Observable.zip(
            source1.asObservable(), source2.asObservable(), source3.asObservable(), source4.asObservable(), source5.asObservable(), source6.asObservable(),
                resultSelector: resultSelector)
            )
    }
}
extension PrimitiveSequenceType where Element == Any, Trait == MaybeTrait {
    public static func zip<E1, E2, E3, E4, E5, E6>(_ source1: PrimitiveSequence<Trait, E1>, _ source2: PrimitiveSequence<Trait, E2>, _ source3: PrimitiveSequence<Trait, E3>, _ source4: PrimitiveSequence<Trait, E4>, _ source5: PrimitiveSequence<Trait, E5>, _ source6: PrimitiveSequence<Trait, E6>)
        -> PrimitiveSequence<Trait, (E1, E2, E3, E4, E5, E6)> {
        return PrimitiveSequence(raw: Observable.zip(
                source1.asObservable(), source2.asObservable(), source3.asObservable(), source4.asObservable(), source5.asObservable(), source6.asObservable())
            )
    }
}
extension PrimitiveSequenceType where Trait == SingleTrait {
    public static func zip<E1, E2, E3, E4, E5, E6, E7>(_ source1: PrimitiveSequence<Trait, E1>, _ source2: PrimitiveSequence<Trait, E2>, _ source3: PrimitiveSequence<Trait, E3>, _ source4: PrimitiveSequence<Trait, E4>, _ source5: PrimitiveSequence<Trait, E5>, _ source6: PrimitiveSequence<Trait, E6>, _ source7: PrimitiveSequence<Trait, E7>, resultSelector: @escaping (E1, E2, E3, E4, E5, E6, E7) throws -> Element)
        -> PrimitiveSequence<Trait, Element> {
            return PrimitiveSequence(raw: Observable.zip(
            source1.asObservable(), source2.asObservable(), source3.asObservable(), source4.asObservable(), source5.asObservable(), source6.asObservable(), source7.asObservable(),
                resultSelector: resultSelector)
            )
    }
}
extension PrimitiveSequenceType where Element == Any, Trait == SingleTrait {
    public static func zip<E1, E2, E3, E4, E5, E6, E7>(_ source1: PrimitiveSequence<Trait, E1>, _ source2: PrimitiveSequence<Trait, E2>, _ source3: PrimitiveSequence<Trait, E3>, _ source4: PrimitiveSequence<Trait, E4>, _ source5: PrimitiveSequence<Trait, E5>, _ source6: PrimitiveSequence<Trait, E6>, _ source7: PrimitiveSequence<Trait, E7>)
        -> PrimitiveSequence<Trait, (E1, E2, E3, E4, E5, E6, E7)> {
        return PrimitiveSequence(raw: Observable.zip(
                source1.asObservable(), source2.asObservable(), source3.asObservable(), source4.asObservable(), source5.asObservable(), source6.asObservable(), source7.asObservable())
            )
    }
}
extension PrimitiveSequenceType where Trait == MaybeTrait {
    public static func zip<E1, E2, E3, E4, E5, E6, E7>(_ source1: PrimitiveSequence<Trait, E1>, _ source2: PrimitiveSequence<Trait, E2>, _ source3: PrimitiveSequence<Trait, E3>, _ source4: PrimitiveSequence<Trait, E4>, _ source5: PrimitiveSequence<Trait, E5>, _ source6: PrimitiveSequence<Trait, E6>, _ source7: PrimitiveSequence<Trait, E7>, resultSelector: @escaping (E1, E2, E3, E4, E5, E6, E7) throws -> Element)
        -> PrimitiveSequence<Trait, Element> {
            return PrimitiveSequence(raw: Observable.zip(
            source1.asObservable(), source2.asObservable(), source3.asObservable(), source4.asObservable(), source5.asObservable(), source6.asObservable(), source7.asObservable(),
                resultSelector: resultSelector)
            )
    }
}
extension PrimitiveSequenceType where Element == Any, Trait == MaybeTrait {
    public static func zip<E1, E2, E3, E4, E5, E6, E7>(_ source1: PrimitiveSequence<Trait, E1>, _ source2: PrimitiveSequence<Trait, E2>, _ source3: PrimitiveSequence<Trait, E3>, _ source4: PrimitiveSequence<Trait, E4>, _ source5: PrimitiveSequence<Trait, E5>, _ source6: PrimitiveSequence<Trait, E6>, _ source7: PrimitiveSequence<Trait, E7>)
        -> PrimitiveSequence<Trait, (E1, E2, E3, E4, E5, E6, E7)> {
        return PrimitiveSequence(raw: Observable.zip(
                source1.asObservable(), source2.asObservable(), source3.asObservable(), source4.asObservable(), source5.asObservable(), source6.asObservable(), source7.asObservable())
            )
    }
}
extension PrimitiveSequenceType where Trait == SingleTrait {
    public static func zip<E1, E2, E3, E4, E5, E6, E7, E8>(_ source1: PrimitiveSequence<Trait, E1>, _ source2: PrimitiveSequence<Trait, E2>, _ source3: PrimitiveSequence<Trait, E3>, _ source4: PrimitiveSequence<Trait, E4>, _ source5: PrimitiveSequence<Trait, E5>, _ source6: PrimitiveSequence<Trait, E6>, _ source7: PrimitiveSequence<Trait, E7>, _ source8: PrimitiveSequence<Trait, E8>, resultSelector: @escaping (E1, E2, E3, E4, E5, E6, E7, E8) throws -> Element)
        -> PrimitiveSequence<Trait, Element> {
            return PrimitiveSequence(raw: Observable.zip(
            source1.asObservable(), source2.asObservable(), source3.asObservable(), source4.asObservable(), source5.asObservable(), source6.asObservable(), source7.asObservable(), source8.asObservable(),
                resultSelector: resultSelector)
            )
    }
}
extension PrimitiveSequenceType where Element == Any, Trait == SingleTrait {
    public static func zip<E1, E2, E3, E4, E5, E6, E7, E8>(_ source1: PrimitiveSequence<Trait, E1>, _ source2: PrimitiveSequence<Trait, E2>, _ source3: PrimitiveSequence<Trait, E3>, _ source4: PrimitiveSequence<Trait, E4>, _ source5: PrimitiveSequence<Trait, E5>, _ source6: PrimitiveSequence<Trait, E6>, _ source7: PrimitiveSequence<Trait, E7>, _ source8: PrimitiveSequence<Trait, E8>)
        -> PrimitiveSequence<Trait, (E1, E2, E3, E4, E5, E6, E7, E8)> {
        return PrimitiveSequence(raw: Observable.zip(
                source1.asObservable(), source2.asObservable(), source3.asObservable(), source4.asObservable(), source5.asObservable(), source6.asObservable(), source7.asObservable(), source8.asObservable())
            )
    }
}
extension PrimitiveSequenceType where Trait == MaybeTrait {
    public static func zip<E1, E2, E3, E4, E5, E6, E7, E8>(_ source1: PrimitiveSequence<Trait, E1>, _ source2: PrimitiveSequence<Trait, E2>, _ source3: PrimitiveSequence<Trait, E3>, _ source4: PrimitiveSequence<Trait, E4>, _ source5: PrimitiveSequence<Trait, E5>, _ source6: PrimitiveSequence<Trait, E6>, _ source7: PrimitiveSequence<Trait, E7>, _ source8: PrimitiveSequence<Trait, E8>, resultSelector: @escaping (E1, E2, E3, E4, E5, E6, E7, E8) throws -> Element)
        -> PrimitiveSequence<Trait, Element> {
            return PrimitiveSequence(raw: Observable.zip(
            source1.asObservable(), source2.asObservable(), source3.asObservable(), source4.asObservable(), source5.asObservable(), source6.asObservable(), source7.asObservable(), source8.asObservable(),
                resultSelector: resultSelector)
            )
    }
}
extension PrimitiveSequenceType where Element == Any, Trait == MaybeTrait {
    public static func zip<E1, E2, E3, E4, E5, E6, E7, E8>(_ source1: PrimitiveSequence<Trait, E1>, _ source2: PrimitiveSequence<Trait, E2>, _ source3: PrimitiveSequence<Trait, E3>, _ source4: PrimitiveSequence<Trait, E4>, _ source5: PrimitiveSequence<Trait, E5>, _ source6: PrimitiveSequence<Trait, E6>, _ source7: PrimitiveSequence<Trait, E7>, _ source8: PrimitiveSequence<Trait, E8>)
        -> PrimitiveSequence<Trait, (E1, E2, E3, E4, E5, E6, E7, E8)> {
        return PrimitiveSequence(raw: Observable.zip(
                source1.asObservable(), source2.asObservable(), source3.asObservable(), source4.asObservable(), source5.asObservable(), source6.asObservable(), source7.asObservable(), source8.asObservable())
            )
    }
}