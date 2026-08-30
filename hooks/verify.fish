#!/usr/bin/env fish

echo "🔍 [Verify] 빌드 및 타입/린트 검증 시작..."

# 1. Rust 스택
if test -f Cargo.toml
    echo "🦀 [Rust] Cargo 프로젝트 감지"
    cargo check --quiet; or exit 1
    cargo clippy --quiet -- -D warnings; or exit 1
    echo "✅ [Pass] Rust 검증 통과!"
    exit 0
end

# 2. TypeScript / JavaScript 스택
if test -f package.json
    echo "📦 [Node/TS] JS/TS 프로젝트 감지"
    biome check .; or exit 1
    npx tsc --noEmit; or exit 1
    echo "✅ [Pass] TS/JS 검증 통과!"
    exit 0
end

# 3. Python 스택 (Ruff + ty)
if test -f pyproject.toml; or test -f requirements.txt
    echo "🐍 [Python] Python 프로젝트 감지"
    ruff check .; or exit 1
    ruff format --check .; or exit 1
    ty check .; or exit 1
    echo "✅ [Pass] Python 검증 통과!"
    exit 0
end

# 4. C# / .NET 스택 (Fish 와일드카드 에러 방지 처리만 적용)
if count *.csproj >/dev/null 2>&1; or count *.sln >/dev/null 2>&1
    echo "⚡ [C#] .NET 프로젝트 감지"
    dotnet build --nologo -v q; or exit 1
    echo "✅ [Pass] C# 검증 통과!"
    exit 0
end

echo "⚠️ [Notice] 감지된 프로젝트 매니페스트가 없습니다."
