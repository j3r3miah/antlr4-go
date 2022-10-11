namespace java com.foo.api

enum UserType {
    STANDARD,
    ADMIN
}

struct User {
    1: optional i64 id
    2: optional UserType userType
    3: string firstName
    4: string lastName
    5: string email
}
