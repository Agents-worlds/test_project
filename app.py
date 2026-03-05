import streamlit as st
import pandas as pd
import numpy as np

st.title("🎉 Streamlit 데모 앱")

st.write("간단한 Streamlit 예제입니다!")

# 사이드바
st.sidebar.header("설정")
user_name = st.sidebar.text_input("이름을 입력하세요", value="방문자")

# 메인 화면
st.header(f"안녕하세요, {user_name}님! 👋")

# 슬라이더 예제
st.subheader("슬라이더 예제")
number = st.slider("숫자를 선택하세요", 0, 100, 50)
st.write(f"선택한 숫자: **{number}**")

# 버튼 예제
st.subheader("버튼 예제")
if st.button("클릭하세요!"):
    st.balloons()
    st.success("🎉 버튼이 클릭되었습니다!")
else:
    st.info("버튼을 클릭해보세요!")

# 데이터 프레임 예제
st.subheader("데이터 프레임 예제")
df = pd.DataFrame(
    {
        "x": np.arange(10),
        "y": np.random.randn(10),
        "z": np.random.choice(["A", "B", "C"], 10),
    }
)
st.dataframe(df)

# 차트 예제
st.subheader("라인 차트 예제")
chart_data = pd.DataFrame(np.random.randn(20, 3), columns=["a", "b", "c"])
st.line_chart(chart_data)

# 푸터
st.markdown("---")
st.markdown("Made with ❤️ using Streamlit")
