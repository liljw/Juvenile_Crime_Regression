
# 정리

install.packages("car")
library(car)
 회귀분석은 언제하는가?

1. 인과관계 파악
2. 독립변수가 종속변수에게 유의한 영향을 주는지 통계적으로 검정
3. 예측, 분류

### 회귀 분석의 주요 용어

- 독립변수 : 설명변수 (원인)
- 종속변수 : 반응변수 (결과)
- 회귀모형 : 종속변수와 독립변수를 설정하는 방법
- 회귀계수 : 회귀직선에서의 절편, 기울기
- 최소제곱법 : 회귀계수를 추정하는 방법 (least square method)

### 회귀분석의 종류

- 단순회귀분석 : 종속변수 1개, 독립변수 1개
- 다중회귀분석 : 종속변수 1개, 독립변수 2개 이상

---

## 단순회귀분석 (Simple Regression Analysis)

- 데이터명 : SRD ("school_report_data.csv")
- 변수명 : rpt_youthcrime, rpt_violence, cnt_bell

- 회귀모형 : rpt_youthcrime = 700.34 + 0.14*cnt_bell + error

- 산점도(scatter plot) : `plot(SRD$rpt_youthcrime ~ SRD$cnt_bell)`

- 회귀모델 도출 : `lm(rpt_youthcrime ~ cnt_bell, data=SRD)`
    - lm : linear model
    - `summary()` : 회귀분석 결과물

---

### 단순회귀분석 결과의 해석

#### 1단계

Q : 회귀모형은 통계적으로 타당한가?  
- 귀무가설 : 회귀모형은 타당하지 않다.  
- 대립가설 : 회귀모형은 타당하다.

회귀분석 결과물(`summary()`) : F-statistic:  1.05 on 1 and 23 DF,  p-value: 0.3162
- F통계량 : 1.05
- 자유도1 : 1
- 자유도2 : 23
- 유의확률 : 0.3162

결론 :   
자유도가 1,23인 F분포에서   
표본에서 관찰된 F통계량 1.05는   
귀무가설이 참이라는 가정 하에서 일어날 수 있는 확률(유의확률)이   
0.32이므로 유의수준 0.05에서 '회귀모형은 타당하지 않다'라는 귀무가설을 기각할 수 없다.

#### 2단계 (예시)

1단계에서 대립가설이 채택되었을 경우에만 2단계를 진행.

Q : 독립변수는 종속변수에 통계적으로 유의한 영향을 주는가?
- 귀무가설 : 영향을 주지 않는다. (회귀계수가 0) 
- 대립가설 : 영향을 준다. (회귀계수가 0이 아니다)

회귀분석 결과물   

                 Estimate Std. Error t value Pr(>|t|)    

    speed         3.9324     0.4155   9.464 1.49e-12 ***

- speed의 회귀계수            : 3.9324
- speed의 회귀계수의 표준오차 : 0.4155
- t통계량                     : 9.464 
- 유의확률                    : 0.000

결론 :  
자유도가 49인 t분포에서  
표본에서 관찰된 t통계량 9.464는  
귀무가설이 참이라는 가정하에서 일어날 확률(유의확률)이  
0.000 이므로 유의수준 0.05에서  
'독립변수는 종속변수에게 통계적으로 유의한 영향을 준다' 라는 대립가설을 채택.  

#### 3단계

2단계에서 결론이 대립가설인 경우에만 3단계를 진행한다.

Q. 독립변수는 종속변수에게 어떠한 영향을 주는가?

회귀분석 결과물   

               Estimate  
    speed         3.9324

- speed의 회귀계수 : 3.9324

결론 :  
speed의 기본단위가 1 증가하면 dist는 약 3.932정도 증가한다.  
speed가 1 mph 증가하면 dist는 약 3.9324 feet 정도 증가한다.


#### 4단계

Q. 회귀모형의 설명력 = 독립변수의 설명력은 얼마인가?

- 회귀분석의 결과물 : Multiple R-squared:  0.6511
- 결정계수(Coefficient of determination) = R^2 = 0.6511

결론 :  
회귀모형의 설명력은 약 65.1% 이다.  
speed가 dist의 다름을 약 65.1% 설명하고 있다.


#### 5단계 

Q. 회귀모형은 예측(Prediction)은?

회귀분석의 결과물 :  

                Estimate   
    (Intercept) -17.5791  
    speed         3.9324

- 절편의 추정치 : -17.5791
- 기울기의 추정치 : 3.9324

- 회귀 추정식 : dist = -17.5791 + 3.9324*speed

결론 :  
어떤 자동차의 speed가 200이면  
dist = -17.5791 + 3.9324*200 = 468.9009로 예측할 수 있다.

- predict(cars.model, newdata=data.frame(speed=200)) cars.model : 회귀모형, newdata : argument

- predict(cars.model, newdata=data.frame(speed=c(100, 200, 300))) 여러개를 보고 싶을때

---

### 잔차분석(Residual Analysis)  

단순회귀분석을 위한 가정(Assumption)들은 만족하는지를 확인  

잔차(Residual)
1. 정규성(Normality)
2. 등분산성(Homoscedasticity)
3. 독립성(Independence)
4. 선형성(Linearity)

#### 정규성(Normality)  

종속변수가 정규분포를 따른다면,  
잔차(residual value) 또한 정규분포를 따르며, 평균은 0 이다.  

- Normal Q-Q plot :  
x축은 잔차의 사분위수(Quartiles),  
y축은 잔차의 표준화.  
정규성 가정을 만족한다면 Normal Q-Q plot는 직선에 가까운 그래프가 되어야 한다.  
직선을 벗어나는 점들이 많으면 정규성 가정이 깨질 가능성이 높다.

- qqnorm(cars.model$residuals)
- qqline(cars.model$residuals)
- shapiro-Wilk test : 잔차에 대해서 정규성 검정을 한다.


#### 등분산성(Homoscedasticity)  
x축 : 독립변수 또는 종속변수의 추정치
y축 : 잔차 또는 표준화 잔차
분산이 일정하다는 가정을 만족한다면
잔차의 값이 0을 기준으로 위/아래로 랜덤random)하게 분포되어 있어야 한다.
일정한 패턴을 가지면 등분산성은 깨진다.

plot(cars$speed, cars.model$residuals)

plot(cars.model$fitted.values, cars.model$residuals)

car::ncvTest(cars.model) 등분산검정(귀무: 등분산이다, 대립 : 이분산이다)


(3) 독립성(Independence)
종속변수는 서로 독립적이어야 한다. 
관찰값들 사이에 상관관계가 있을 경우,
오차항들이 서로 독립이라는 조건을 검토해 보아야 한다. 
만일 오차항들이 서로 독립이라면, 잔차들은 무작위로 흩어져 있을 것이고, 
그렇지 않다면 무작위로 흩어져 있지 않아 오차항들 사이에 상관관계가 있다고 할 수 있을 것이다. 


i. 더빈-왓슨 통계량(Durbin-Watson Statistics)
오차항의 독립성을 평가하는 한 측도로 더빈-왓슨(Durbin-Watson) 통계량이 있다. 
DW 통계량은 잔차들의 상관계수를 측정함
DW 통계량이 2에 가까우면 인접 오차항들 사이에 상관관계가 없는 것을 의미하며, 
DW 통계량이 4에 가까우면 음의 상관관계가 있고
DW 통계량이 0에 가까우면 양의 상관관계가 있는 것으로 평가한다.


귀무가설 : 각 오차들은 서로 독립이다.
대립가설 : 각 오차들은 서로 독립이 아니다.
lmtest::dwtest(회귀분석결과물)

lmtest::dwtest(cars.model)




(4) 선형성(Linearity)
종속변수와 독립변수가 선형관계에 있다면
잔차와 독립변수 사이에 어떤 체계적인 관계가 있으면 안 된다. 

plot(cars$speed, cars.model$residuals)





회귀모형에 대한 전반적인 검정      #

검정결과 = gvlma::gvlma(회귀분석결과물)
summary(검정결과)

gvlma.result = gvlma::gvlma(cars.model)

summary(gvlma.result)


해석
Call:
gvlma(x = cars.model) 


                    Value     p-value     Decision
Global Stat        15.801    0.003298   Assumptions NOT satisfied!
    Skewness        6.528    0.010621   Assumptions NOT satisfied!
    Kurtosis        1.661    0.197449   Assumptions acceptable.
Link Function       2.329    0.126998   Assumptions acceptable.
Heteroscedasticity  5.283    0.021530   Assumptions NOT satisfied!


i.   Global Stat        : 회귀모형에 대한 전반적인 가정에 대한 검정 결과
ii.  Skewness           : 정규성   검정 
iii. Kurtosis           : 정규성   검정
iv.  Link function      : 선형성   검정
V.   Heteroscedasticity : 등분산성 검정






6. 영향력
잔차(residual) vs 영향력(leverage) 그래프에서는 
주의를 기울여야 하는 개개의 관찰치에 대한 정보를 제공한다. 
i. 이상치(outlier) 
ii. 큰 지레점(high leverage point) 
iii. 영향관측치(influential observation)
를 확인할 수 있다.


i. 이상치(outlier)
회귀모형으로 잘 예측되지 않는 관측치(즉 아주 큰 양수/음수의 residual)
표준화 제외 잔차(Studentized Deleted Residual) : 절대값이 2보다 크면 이상치거나 영향치
DFFITS(Diffrence of Fits) : 2*루트((독립변수의 개수 + 1) / 데이터의 개수)) 보다 크면 이상치거나 영향치
DFBETAS(Difference of Betas) : 2 또는 2 / 루트(데이터의 개수) 보다 크면 이상치거나 영향치

rstudent(cars.model)[rstudent(cars.model) >= 2]

car::outlierTest(cars.model)이상치 여부를 판단했는데, 49번째 있는 값이 이상치 이다.


ii. 큰 지레점(high leverage point)
비정상적인 예측변수의 값에 의한 관측치. 
즉 예측변수측의 이상치로 볼 수 있다. 
종속변수의 값은 관측치의 영향력을 계산하는 데 사용하지 않는다.

car::leveragePlots(cars.model)

plot(hatvalues(cars.model), type = "h")


iii. 영향관측치(influential observation)
통계 모형 계수 결정에 불균형한 영향을 미치는 관측치로 
Cook’s distance라는 통계치로 확인할 수 있다.

cooks.distance(cars.model)






