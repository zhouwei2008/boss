package boss

class BoAdjustType {
    Long id
    String name

    static constraints = {
        id(size: 1..19, blank: false, unique: true)
        name(size: 1..32, blank: false)
    }
}