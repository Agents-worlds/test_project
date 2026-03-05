# Streamlit 데모 앱

간단한 Streamlit 예제 프로젝트입니다. Streamlit의 다양한 기능을 데모 형태로 보여줍니다.

## 📋 기능

- **사용자 입력**: 사이드바에서 이름 입력
- **슬라이더**: 0~100 범위의 숫자 선택
- **버튼**: 클릭 시 풍선 애니메이션 표시
- **데이터프레임**: Pandas를 활용한 데이터 테이블 표시
- **라인 차트**: 실시간 랜덤 데이터 시각화

## 🛠️ 기술 스택

- Python 3.14+
- Streamlit 1.55.0+
- Pandas
- NumPy

## 📦 설치

### 요구사항

- Python 3.14 이상
- uv (Python 패키지 매니저)

### 설치 방법

1. 저장소 클론

```bash
git clone <repository-url>
cd test_project
```

2. 의존성 설치

```bash
uv sync
```

## 🚀 실행

### Streamlit 앱 실행

```bash
uv run streamlit run app.py
```

### Python 환경 확인

```bash
uv run python main.py
```

## 📁 프로젝트 구조

```
test_project/
├── app.py              # Streamlit 데모 앱
├── main.py             # Python 환경 확인 스크립트
├── pyproject.toml      # 프로젝트 설정
├── uv.lock            # 의존성 잠금 파일
└── README.md          # 이 파일
```

## 🎯 사용 방법

1. 앱을 실행하면 브라우저가 자동으로 열립니다 (기본: http://localhost:8501)
2. 사이드바에서 이름을 입력하세요
3. 슬라이더로 숫자를 선택해보세요
4. "클릭하세요!" 버튼을 눌러 풍선 애니메이션을 확인하세요
5. 데이터프레임과 라인 차트를 확인하세요

## 📝 라이선스

이 프로젝트는 학습 및 데모 목적으로 제작되었습니다.

---

Made with ❤️ using Streamlit
