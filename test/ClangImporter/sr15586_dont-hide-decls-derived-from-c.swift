// Confirm that SR-15586 is resolved.

// RUN: %empty-directory(%t)
// RUN: cd %t
// RUN: echo '#include <netinet/in.h>' >c.h
// RUN: echo 'public typealias A = in_addr'  >library.swift
// RUN: echo 'extension A {'                >>library.swift
// RUN: echo '  public var foo: String {'   >>library.swift
// RUN: echo '    return "foo"'             >>library.swift
// RUN: echo '  }'                          >>library.swift
// RUN: echo '}'                            >>library.swift
// RUN: %target-swiftc_driver library.swift -import-objc-header c.h \
// RUN:   -emit-module -emit-library -module-name MyLibrary
// RUN: %target-swiftc_driver %s -I%t -L%t -lMyLibrary -o %t/main
// RUN: LD_LIBRARY_PATH=%t %t/main | %FileCheck %s

#if canImport(Darwin)
  import Darwin
#elseif canImport(Glibc)
  import Glibc
#endif

import MyLibrary
let a = A()
print(a.foo)
// CHECK: {{^foo$}}

