//
//  7.swift
//  Questions
//
//  Created by admin1 on 1.06.23.
//

import Foundation

protocol SomeProtocol {
    // определение протокола SomeProtocol
}

protocol AnotherProtocol {
    // определение протокола AnotherProtocol
}

protocol InheritingProtocol: SomeProtocol, AnotherProtocol {
    // определение протокола InheritingProtocol
}

/*
Протокол может наследовать один или более других протоколов. Также, как и класс,
протокол добавляет требования поверх тех требований протоколов, которые наследует.

В нашем примере протокол InheritingProtocol должен удовлетворять всем требованиям
протоколов SomeProtocol и AnotherProtocol.
*/

Дополнительное чтение: https://swiftbook.ru/content/languageguide/protocols/
