FROM adoptopenjdk/openjdk11 AS builder
ARG SERVICE_NAME=book

COPY gradlew .
COPY gradle gradle
COPY build.gradle .
COPY settings.gradle .

# 개선할 부분
COPY book ./book
COPY review ./review
COPY timer ./timer
COPY user ./user
COPY util ./util

# COPY /var/conf/env.properties src/main/resources/properties/
RUN chmod +x ./gradlew
RUN ./gradlew :${SERVICE_NAME}:bootJAR

FROM adoptopenjdk/openjdk11
# (아마도) FROM 절 다음에 변수를 한번 더 선언해줘야 한다. FROM절로 area가 나뉘는 듯 하다.
# 외부에서 할당한 SERVICE_NAME 값은 위 FROM과 아래 FROM 모두 적용된다.
ARG SERVICE_NAME=book
COPY --from=builder ${SERVICE_NAME}/build/libs/*.jar app.jar
ENTRYPOINT ["java", "-jar", "/app.jar", "--server.port=8080"]

# 외부에서 변수 값 할당 예시: docker build --build-arg SERVICE_NAME=user .