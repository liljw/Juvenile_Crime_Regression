
getwd()
setwd("/Users/kimjiewoo/R_project/data_working/")

rm(list=ls())

# 최종 데이터셋 불러오기 ------------------------------------------------------------

SRD <- read.csv("../rawdata/최종데이터/school_report_data.csv")

View(SRD)



# 분석 방향 정하기 ---------------------------------------------------------------

# ○ 메인 주제1
# 종속(y) : 비행/학폭 
# 독립(x) : 비상벨
# 가설 : 비상벨 개수가 많은 지역일수록 비행 또는 학교 폭력 신고 수가 적을 것이다.
# 분석 방법 : 단순 선형 회귀 분석
# 귀무 가설 : 비상벨 개수와 비행 또는 학교 폭력 신고 수는 선형 관계가 없다.
# 대립 가설 : 비상벨 개수와 비행 또는 학교 폭력 신고 수는 선형 관계가 있다.
# 분석 기획
# 1. 전처리
# 2. 정규성 검정
# 3. 독립성 검정
# 4. 등분산성 검정
# 5. 단순 선형 회귀 분석
# 
# 
# ○ 메인 주제2
# 종속(y) : 비행/학폭
# 독립(x) : 무인텔수, 생활숙박시설수, 여행숙박시설수 제외
# 가설 : 유흥 시설 개수가 많은 지역일수록 비행 또는 학교 폭력 신고 수가 많을 것이다.
# 분석 방법 : 다중 선형 회귀 분석
# 귀무 가설 : 모든 독립 변수에 대해서 비행 또는 학교 폭력 신고 수는 선형 관계가 없다.
# 대립 가설 : 어떤 독립 변수에 대해서 비행 또는 학교 폭력 신고 수는 선형 관계가 있다.
# 분석 기획
# 1. 전처리
# 2. 정규성 검정
# 3. 독립성 검정
# 4. 등분산성 검정
# 5. 다중 선형 회귀 분석


# 메인 주제 1 -----------------------------------------------------------------


## 소주제 1-1 : 비행청소년 신고 빈도 ~ 비상벨 개수 

plot(SRD$cnt_bell, SRD$rpt_youthcrime)

boxplot(SRD$rpt_youthcrime)
boxplot(SRD$cnt_bell)

## 회귀 모델 도출

lm1_1 <- lm(rpt_youthcrime ~ cnt_bell, SRD)

summary(lm1_1)

## 정규성 검정
### 독립변수의 잔차의 정규성을 검정하는 것!
#### H0 : 데이터셋이 정규분포를 따른다.
#### H1 : 데이터셋이 정규분포를 따르지 않는다. 

qqnorm(SRD$cnt_bell)
qqline(SRD$cnt_bell, col="red")

shapiro.test(SRD$cnt_bell)
# p.value : 0.1011 이므로 0.05(유의수준) 보다 크니까 귀무가설을 기각할 수 없다.
# 정규성 있음! 

## 독립성 검정
### 단순 회귀 분석에서는 독립변수가 하나이기 때문에 독립성 검정을 할 필요가 없다. 


## 등분산성 검정
### 잔차의 등분산성을 검정하는 것!
#### H0 : 잔차들은 등분산성을 띈다.
#### H1 : 잔차들은 등분산성을 띄지 않는다. (이분산이다.) 

plot(lm1_1,5)

car::ncvTest(lm1_1)
### ncvTest 결과 p값이 0.85로 0.05보다 크니 귀무가설을 기각할 수 없다.


## 단순 선형 회귀 결과 분석
summary(lm1_1)

### 결론 
### 단순 선형 회귀 분석 결과 기울기는 0.14로 0에 가깝고, p 값은 0.31로 0.05(유의수준)보다 큰 값이 나왔으므로
### 귀무가설을 기각할 수 없다는 결론을 도출할 수 있다. 
### 따라서 비행청소년 신고 수와 비상벨 설치 개수 사이에는 선형 관계가 없다. 


## 소주제 1-2 : 학교폭력 신고 빈도 ~ 비상벨 개수 

boxplot(SRD$rpt_violence)
boxplot(SRD$cnt_bell)

plot(SRD$rpt_violence ~ SRD$cnt_bell)

### 회귀 모델 도출

lm1_2 <- lm(rpt_violence ~ cnt_bell, SRD)

### 정규성 검정

#### 중복이므로 생략

### 등분산성 검정

plot(lm1_2,5)

car::ncvTest(lm1_2)

## p값이 0.56 으로 0.05 보다 크니까 잔차가 등분산이다.

## 단순 선형 회귀 결과 분석
summary(lm1_2)


# 메인 주제 2 -----------------------------------------------------------------

## 소주제 2-1 : 비행청소년 신고 빈도 ~ 유흥시설 개수

## 데이터셋 전처리 (무인텔, 숙박시설들 제외)

SRD2 <- SRD %>% select(-cnt_motel, -cnt_accm_travel, -cnt_accm_living, -cnt_bell)
View(SRD2)

plot(SRD2)  

SRD2 %>% arrange(desc(cnt_adultgame)) %>% head(3)  # 상위 3개 행정구역 : 관악구, 구로구, 강북구
SRD2 %>% arrange(desc(cnt_bar)) %>% head(3)  # 상위 3개 행정구역 : 강남구, 마포구, 송파구
SRD2 %>% arrange(desc(cnt_club)) %>% head(3)  # 상위 3개 행정구역 : 강남구, 마포구, 용산구


## 회귀 모델 도출 

lm2_1 <- lm(rpt_youthcrime ~ cnt_danran + cnt_adultgame + cnt_bar + cnt_yuheung + cnt_club, SRD2)

## 유의하지 않은 변수 제거

lm2_1 <- step(lm2_1, direction="both")

### step() : 처음에 생성했던 다중 회귀 모델을 가지고 유의하지 않은 독립변수들을 하나씩 제거, 혹은 추가 해보면서
### 전체적인 다중 회귀 분석 모형의 적합도가 유의해질 때 까지(p 값이 0.05 이하가 될 때까지) 위의 작업을 실행하고, 
### 적합도가 유의해지면 해당 결과를 반환한다. 

lm2_1

summary(lm2_1)


# 결론 : 단란주점이라는 독립변수는 비행청소년 신고 빈도 수라는 종속변수에 통계적으로 유의미한 영향을 준다.
# 반면 나머지 독립변수들은 종속변수에 통계적으로 유의미한 영향을 주지 않는다. 

# 결과에 영향을 미치는 유의미한 독립변수는 있었지만, 설명력이 떨어지므로 해당 다중 회귀 분석 모델은 폐기한다.

# 단란주점에 대한 정규성, 등분산성 검정
# 유의한 변수는 단란주점 한 개 뿐이므로 독립성 검정은 실행하지 않는다. 

## 정규성

qqnorm(SRD2$cnt_danran)
qqline(SRD2$cnt_danran, col="red")

shapiro.test(SRD2$cnt_danran)

## 정규성 없음!!!!! -> 데이터 개수가 작으므로 크게 고려하진 않는다.

## 등분산성

car::ncvTest(lm2_1)

## 등분산이다.

## 소주제 2-2 : 비행청소년 신고 빈도 ~ 유흥시설 개수

lm2_2 <- lm(rpt_violence ~ cnt_danran + cnt_adultgame + cnt_bar + cnt_yuheung + cnt_club, SRD2)

lm2_2 <- step(lm2_2, direction="both")

summary(lm2_2)

## 다중 회귀 분석 모형의 적합성이 유의미하지 않다. 


# 2) 1. 서울시 전국
      # 1-1 : 비행청소년 -> 서울시와 결과 비슷

# 2-1 번과 결론 같음

      # 2-2 : 학교폭력 -> 서울시와 결과 다름

# 결론 : 선택한다면 -> 다중공선성 및 기타 사후 검정 필요 
# 채택하지 하지 않는다면 모델 폐


#    2. 유흥 ~ 비상벨





# 정규화 ---------------------------------------------------------------------

install.packages("caret")
library(caret)

SRD2_norm <- SRD2 %>% select(cnt_danran, cnt_adultgame, cnt_bar, cnt_yuheung, cnt_club) %>% preProcess(method=c("range"))

SRD2_norm <- predict(SRD2_norm, SRD2)

View(SRD2_norm)

##

SRD2_norm_2 <- SRD2 %>% preProcess(method=c("range"))

SRD2_norm_2 <- predict(SRD2_norm_2, SRD2)

View(SRD2_norm)


lm3_2 <- lm(rpt_youthcrime ~ cnt_danran + cnt_adultgame + cnt_bar + cnt_yuheung + cnt_club, SRD2_norm)

lm3_2 <- step(lm3_2, direction="both")

summary(lm3_2)

## 학교폭력

lm3_2_2 <- lm(rpt_violence ~ cnt_danran + cnt_adultgame + cnt_bar + cnt_yuheung + cnt_club, SRD2_norm)

lm3_2_2 <- step(lm3_2_2, direction="both")

summary(lm3_2_2)



# 유흥 ~ 비상벨 ----------------------------------------------------------------

SRD$cnt_total <- apply(SRD[,5:12], 1, sum)

# 유흥시설 개수가 많으면 비상벨 개수가 많을 것 이다. 
# lm4 <- lm(head(sort(SRD$cnt_bell),20) ~ head(sort(SRD$cnt_total),20), SRD)
# summary(lm4)
# 
# boxplot(SRD$cnt_bell)
# boxplot(SRD$cnt_total)
# 
# head(sort(SRD$cnt_total),20)
# 
# shapiro.test(head(sort(SRD$cnt_total),23))
# 
# qqnorm(SRD$cnt_total)
# qqline(SRD$cnt_total, col="red")



## 전국 유흥 ~ 비상벨

# 1. 비상벨 ~ 법정동코드 -> 비상벨 행정구역 명 열 생성
# 2. 학폭 데이터 비교 후 병합



############## 전국 SRD 데이터셋 가져오기

SRD_K <- read.csv("../rawdata/최종데이터/school_report_data_korea.csv")
View(SRD_K)

SRD_K <- SRD_K %>% filter(cnt_bell != 0)

## 주제 3-1

plot(SRD_K$cnt_bell, SRD_K$rpt_youthcrime)

boxplot(SRD_K$rpt_youthcrime)
boxplot(SRD_K$cnt_bell)

lm3_1 <- lm(rpt_youthcrime ~ cnt_bell, SRD_K)

qqnorm(SRD_K$cnt_bell)
qqline(SRD_K$cnt_bell, col="red")

qqnorm(SRD_K$rpt_youthcrime)
qqline(SRD_K$rpt_youthcrime, col="red")

shapiro.test(SRD_K$cnt_bell)
shapiro.test(SRD_K$rpt_youthcrime)

car::ncvTest(lm3_1)

summary(lm1_1)

## 3-1의 결론 : 선형 관계가 있다고 볼 수 없다. 왜냐면 정규성도 없고, 등분산성도 없어서 
## 단순 선형 회귀 분석의 가정을 만족시키지 못하기 때문이다. 


### 주제 

plot(SRD_K)

SRD_K <- SRD_K %>% filter(cnt_bell != 0)

SRD_K$cnt_total <- apply(SRD_K[,6:13], 1, sum)

# 유흥시설 개수가 많으면 비상벨 개수가 많을 것 이다. 

lm4 <- lm(SRD_K$cnt_bell ~ SRD_K$cnt_total, SRD_K)
lm4
summary(lm4)

plot(lm4)

boxplot(SRD_K$cnt_bell)
boxplot(SRD_K$cnt_total)

head(sort(SRD$cnt_total),30)

shapiro.test(SRD_K$cnt_total)

qqnorm(SRD_K$cnt_total)
qqline(SRD_K$cnt_total, col="red")


plot(SRD_K$cnt_bell ~ SRD_K$cnt_total)
abline(lm4)

preProcess(SRD_K[,6:13])
SRD_K[,6:13] <- SRD_K[,6:13] %>% preProcess(method=c("range")) %>% predict(SRD_K[,6:13])


SRD_K <- SRD_K %>% filter(cnt_total < 3)



# 주제 3-2 사후 검정 ------------------------------------------------------------

View(fsn_row1)

fsn1 <- fsn_row1 %>% select(-cnt_motel, -cnt_accm_living, -cnt_accm_travel)

fsn1[is.na(fsn1)] <- 0

View(fsn1)

## 유흥 시설 개수가 많을 수록 비행 / 학교폭력 신고 수가 많을 것이다.

lm3_2 <- lm(log(rpt_youthcrime) ~ cnt_danran + cnt_adultgame + cnt_bar + cnt_yuheung + cnt_club, fsn1_1)

lm3_2 <- step(lm3_2, direction="both")

summary(lm3_2)


###

fsn1_1 <- fsn1 %>% filter(rpt_youthcrime > 0)

lm3_2_2 <- lm(rpt_violence ~ cnt_danran + cnt_adultgame + cnt_bar + cnt_yuheung + cnt_club, fsn1_1)

lm3_2_2 <- step(lm3_2_2, direction="both")

summary(lm3_2_2)

# 다중공선성 검정

vif(lm3_2)
vif(lm3_2_2)

# 정규성 검정

shapiro.test(fsn1$cnt_adultgame)
qqnorm(fsn1$cnt_adultgame)
qqline(fsn1$cnt_adultgame, col="red")

shapiro.test(fsn1$cnt_bar)
qqnorm(fsn1$cnt_bar)
qqline(fsn1$cnt_bar, col="red")

shapiro.test(fsn1$cnt_club)
qqnorm(fsn1$cnt_club)
qqline(fsn1$cnt_club, col="red")

shapiro.test(fsn1$cnt_yuheung)
qqnorm(fsn1$cnt_yuheung)
qqline(fsn1$cnt_yuheung, col="red")

shapiro.test(fsn1$cnt_club)
qqnorm(fsn1$cnt_club)
qqline(fsn1$cnt_club, col="red")

plot(residuals(lm3_2))
shapiro.test(rstandard(lm3_2))

bartlett.test(fsn1$cnt_adultgame, fsn1$cnt_bar, fsn1$cnt_club )

plot(lm3_2)

hist(residuals(lm3_2))
hist(lm3_2$residuals)

a <- boxplot(fsn1$rpt_youthcrime)
View(fsn1)

###

View(fsn_row1)

fsn_row1$cnt_total <- apply(fsn_row1[,7:14], 1, sum)

fsn_row1$rpt_total <- apply(fsn_row1[,4:6], 1, sum)

fsn10 <- fsn_row1 %>% select(sido, signgu, rpt_total, cnt_total)

View(fsn10)

temp <- fsn10 %>% arrange(desc(rpt_total)) %>% head(10)







