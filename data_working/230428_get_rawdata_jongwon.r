library(tidyverse)
getwd()
setwd("C:/temp")

fsn1 <- read.csv('fsn_row1.csv', header = F)
names(fsn1) <- c('year', 'sido', 'signgu', 
                'rpt_total', 'rpt_youthcrime', 'rpt_violence', 
                'cnt_danran', 'cnt_motel', 'cnt_accm_living', 'cnt_adultgame', 
                'cnt_bar', 'cnt_accm_travel', 'cnt_yuheung', 'cnt_club')
head(fsn1)


fsn2 <- read.csv('fsn_row2.csv', header = T)
head(fsn2)

##### 서울특별시 데이터만 남기기 #####
fsn1_1 <- fsn1 %>% filter(sido == '서울특별시')
fsn2_1 <- fsn2 %>% filter(COLCT_INST == '서울시')
###########


##### 행정구역 데이터 가져오기 #####
fsn3 <- read.csv('fsn_row3.csv', fileEncoding = "euc-kr", header = F)
fsn3 <- fsn3[,-1] %>% filter(V3 != '소계')
length(unique(fsn3$V2))  # 자치구 개수 25개 확인 완료
###########


##### 비상벨 데이터 동 전처리 #####
unique(fsn2_1$TYPE)  # 서울시에는 비상벨만 있음
fsn2_2 <- table(fsn2_1$LEGALDON_N)

a <- sort(unique(fsn2_1$LEGALDON_N))

# 비상벨 데이터의 모든 동은 끝 글자가 '동' 또는 '가' 이다.
length(a) == sum(substr(a, nchar(a), nchar(a)) == '동' | substr(a, nchar(a), nchar(a)) == '가')
# 명륜1가, 명륜3가를 제외하고 모든 동은 끝 글자가 '가'일 경우, 뒤에서 2번째 글자가 '동'이다
sum(substr(a, nchar(a), nchar(a)) == '가' & substr(a, nchar(a)-2, nchar(a)-2) != '로')
sum(substr(a, nchar(a), nchar(a)) == '가' & substr(a, nchar(a)-2, nchar(a)-2) == '동')
a[(substr(a, nchar(a), nchar(a)) == '가' & substr(a, nchar(a)-2, nchar(a)-2) != '로') & !(substr(a, nchar(a), nchar(a)) == '가' & substr(a, nchar(a)-2, nchar(a)-2) == '동')]
# 명륜이 들어간 동은 2개 밖에 없다
sum(substr(a, 1, 2) == '명륜')

# 비상벨 데이터 '동' 처리
# 맨 뒤에 '동' 없애기
a <- ifelse(substr(a, nchar(a), nchar(a)) == '동', substr(a, 1, nchar(a)-1), a)
# 명륜동 예외 처리
a <- ifelse(substr(a, 1, 2) == '명륜', substr(a, 1, 3), a)
# 맨 뒤에 '가' 없애고 중간에 '동' 없애기, '로' 가 들어가는 경우 '가' 만 없애기
a <- ifelse(substr(a, nchar(a), nchar(a)) == '가', 
            ifelse(substr(a, nchar(a)-2, nchar(a)-2) == '로',
                   substr(a, 1, nchar(a)-1),
                   paste0(substr(a, 1, nchar(a)-3), substr(a, nchar(a)-1, nchar(a)-1))), 
            a)
head(a, 200)

names(fsn2_2) <- a
fsn2_2 <- data.frame(fsn2_2)
fsn2_2

##########

##### 자치구 데이터 이름 맞추기 #####
# 신사동 이름 겹침
# library(sf)
# library(mapproj)
