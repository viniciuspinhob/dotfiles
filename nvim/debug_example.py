"""
Debug Example - Como usar o debugpy no Neovim
==============================================

1. Abra este arquivo no Neovim
2. <Space>db na linha que quiser parar (ex: dentro do loop em `baz`)
3. <Space>dl → escolhe "Launch file" para iniciar o debug
4. Quando parar no breakpoint:
   - <Space>di (step into)  → entra dentro da função chamada
   - <Space>do (step over)  → executa a linha sem entrar na função
   - <Space>du (step out)   → volta pra função que chamou
   - <Space>de              → avalia uma expressão (ex: first + second)
   - <Space>dl              → continua até o próximo breakpoint
   - <Space>dp              → pausa a execução
   - <Space>ds              → para o debug
   - <Space>dt              → toggle do painel dap-ui
   - <Space>dw              → float de watches
5. O painel à esquerda mostra: scopes, breakpoints, stacks, watches
6. O painel inferior mostra: REPL e console
"""


def foo(x):
    result = x * 2
    return result


def bar(a, b):
    first = foo(a)
    second = foo(b)
    total = first + second
    return total


def baz(items):
    results = []
    for item in items:
        value = bar(item, item + 1)
       results.append(value)
    return results


def main():
    numbers = [1, 2, 3, 4, 5]
    output = baz(numbers)
    final = sum(output)
    print(f"results: {output}")
    print(f"final: {final}")


if __name__ == "__main__":
    main()
