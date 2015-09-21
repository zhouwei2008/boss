package ismp

class NotifyFailWatcher {
    static mapping = {
        id generator: 'sequence', params: [sequence: 'seq_notify_fail_watcher']
    }
    String name
    String mobile
    String email

    static constraints = {
        name(size: 1..10, blank: false)
        mobile(size: 1..11, nullable: true)
        email(size: 1..100, nullable: true)
    }
}
