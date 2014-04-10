#lang racket

(require rackunit)
(require rackunit/text-ui)

;; Exemplo 7.1

;; Lista(Número) -> Lista(Número)
;; Converte uma lista de distâncias relaticas para uma lista de distâncias
;; absolutas. O primeito item da lista representa a distância da origem.

(define relativa->absoluta-tests
  (test-suite
   "relativa->absoluta tests"
   (check-equal? (relativa->absoluta empty) empty)
   (check-equal? (relativa->absoluta (list 50 40 70 30 30))
                 (list 50 90 160 190 220))))

;; Definição sem uso de acumulador
#;
(define (relativa->absoluta lst)
  (define (somador n) (λ (x) (+ x n)))
  (cond
    [(empty? lst) empty]
    [else
     (cons (first lst)
           (map (somador (first lst))
                (relativa->absoluta (rest lst))))]))

;; Definição usando acumulador
(define (relativa->absoluta lst0)
  (define (rel->abs lst acc-dist)
    (cond
      [(empty? lst) empty]
      [else
       (cons (+ (first lst) acc-dist)
             (rel->abs (rest lst)
                       (+ (first lst) acc-dist)))]))
  (rel->abs lst0 0))

;; ---------------------------------------------------------------------

;; Exemplo 7.2

;; Lista -> Natural
;; Conta a quantidade de elementos de uma lista.
(define tamanho-tests
  (test-suite
   "tamanho tests"
   (check-equal? (tamanho empty)
                 0)
   (check-equal? (tamanho (list 4))
                 1)
   (check-equal? (tamanho (list 4 7))
                 2)
   (check-equal? (tamanho (list 4 8 -4))
                 3)))

;; Definição sem uso de acumulador
#;
(define (tamanho lst)
  (cond
    [(empty? lst) 0]
    [else (add1 (tamanho (rest lst)))]))

;; Definição com o uso de acumlador
#;
(define (tamanho lst0)
  (define (iter lst acc)
    (cond
      [(empty? lst) acc]
      [else (iter (rest lst) (add1 acc))]))
  (iter lst0 0))

;; Definição em termos de reduz-acc
(define (tamanho lst)
  (define (soma1-no-segundo a b)
    (add1 b))
  (reduz-acc soma1-no-segundo 0 lst))

;; ---------------------------------------------------------------------

;; Exemplo 7.3

;; Lista(Número) -> Número
;; Soma os números de uma lista.
(define soma-tests
  (test-suite
   "soma tests"
   (check-equal? (soma empty)
                 0)
   (check-equal? (soma (list 3))
                 3)
   (check-equal? (soma (list 3 5))
                 8)
   (check-equal? (soma (list 3 5 -2))
                 6)))

;; Definição sem acumulador
#;
(define (soma lst)
  (cond
    [(empty? lst) 0]
    [else (+ (first lst)
             (soma (rest lst)))]))

;; Definição com uso de acumulador
#;
(define (soma lst0)
  (define (iter lst acc)
    (cond
      [(empty? lst) acc]
      [else
       (iter (rest lst) (+ (first lst) acc))]))
  (iter lst0 0))

;; Definição em termos de reduz-acc
(define (soma lst)
  (reduz-acc + 0 lst))

;; ---------------------------------------------------------------------

;; Exemplo 7.4

;; Lista -> Lista
;; Inverte a ordem dos elmentos de lst.
(define inverte-tests
  (test-suite
   "inverte tests"
   (check-equal? (inverte empty) empty)
   (check-equal? (inverte (list 2)) (list 2))
   (check-equal? (inverte (list 2 8 9)) (list 9 8 2))))

;; Definição sem uso de acumlador
#;
(define (inverte lst)
  (cond
    [(empty? lst) empty]
    [else (append (inverte (rest lst))
                  (list (first lst)))]))

;; Definição com o uso de acumulador
#;
(define (inverte lst0)
  (define (iter lst acc)
    (cond
      [(empty? lst) acc]
      [else (iter (rest lst)
                  (cons (first lst) acc))]))
  (iter lst0 empty))

;; Definição em termos de reduz-acc
(define (inverte lst)
  (reduz-acc cons empty lst))


;; ---------------------------------------------------------------------

;; Usando a técnica para criar funções abstratas a partir de exemplos,
;; criamos a função reduz-acc baseado nas funções (com acumulador)
;; tamanho, soma e inverte.

;; (X Y -> X) Y Lista(X) -> Y
;; (reduz-acc f base (list x1 x2 ... xn) devolve
;; (fn xn ... (f2 x2 (f x1 base)))
;; Veja a função pré-definida foldl.
(define (reduz-acc f base lst0)
  (define (iter lst acc)
    (cond
      [(empty? lst) acc]
      [else (iter (rest lst)
                  (f (first lst) acc))]))
  (iter lst0 base))

;; ---------------------------------------------------------------------

;;;;;;;;;;;;;;;;;;;;
;; Funções para auxiliar nos testes

;; Teste ... -> Void
;; Executa um conjunto de testes.
(define (executa-testes . testes)
  (run-tests (test-suite "Todos os testes" testes))
  (void))

;; Chama a função para executar os testes.
(executa-testes relativa->absoluta-tests
                tamanho-tests
                soma-tests
                inverte-tests)