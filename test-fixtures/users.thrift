namespace java com.foo.api

enum UserType {
    STANDARD = 0,
    ADMIN =1,
}

struct User {
    1: optional i64 id (non_null)
    2: optional UserType userType
    3: string firstName
    4: string lastName
    5: string email (non_null)
}
