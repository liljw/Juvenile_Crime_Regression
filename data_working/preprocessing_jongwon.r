#install.packages('sf')
#install.packages('mapproj')
# library(sf)
# library(mapproj)
library(tidyverse)
options('scipen' = 100)
setwd('C:/Users/HPE/데면대면')

substrRight <- function(x, n) {
  substr(x, nchar(x)-n+1, nchar(x))
}

# 청소년 비행 데이터
fsn1 <- read.csv('fsn_row1.csv', header = F)
names(fsn1) <- c('year', 'sido', 'signgu', 'rpt_total', 
                 'rpt_youthcrime', 'rpt_violence', 'cnt_danran', 
                 'cnt_motel', 'cnt_accm_living', 'cnt_adultgame', 
                 'cnt_bar', 'cnt_accm_travel', 'cnt_yuheung', 
                 'cnt_club')


# ##### shp 파일을 불러와서 csv로 변환 #####
# fsn_row2 <- st_read('FSN_30_20221130_G_001/FSN_30_20221130_G_001.shp')
# View(fsn_row2)
# head(fsn_row2)
# fsn_row2 <- as.data.frame(fsn_row2)
# fsn_row2 <- fsn_row2[,-7]
# write.csv(fsn_row2, 'fsn_row2.csv', row.names = F)
##########

# 비상벨 데이터 불러오기
fsn2 <- read.csv('fsn_row2.csv', header = T)
fsn2_1 <- fsn2

# ##### 청소년 비행/가로등 데이터에서 서울특별시만 남기기 #####
# fsn1_1 <- fsn1 %>% filter(sido == '서울특별시')
# fsn2_1 <- fsn2 %>% filter(COLCT_INST == '서울시')
# ###########

# ##### 행정구역 데이터 가져오기 #####
# fsn3 <- read.csv('fsn_row3.csv', fileEncoding = "euc-kr", header = F)
# fsn3 <- fsn3[,-1] %>% filter(V3 != '소계')
# length(unique(fsn3$V2))  # 자치구 개수 25개 확인 완료
# ###########


# ##### 비상벨 데이터 동 전처리 #####
# unique(fsn2_1$TYPE)  # 서울시에는 비상벨만 있음
# fsn2_2 <- table(fsn2_1$LEGALDON_N)
# 
# a <- sort(unique(fsn2_1$LEGALDON_N))
# 
# # 비상벨 데이터의 모든 동은 끝 글자가 '동' 또는 '가' 이다.
# length(a) == sum(substr(a, nchar(a), nchar(a)) == '동' | substr(a, nchar(a), nchar(a)) == '가')
# # 명륜1가, 명륜3가를 제외하고 모든 동은 끝 글자가 '가'일 경우, 뒤에서 2번째 글자가 '동'이다
# sum(substr(a, nchar(a), nchar(a)) == '가' & substr(a, nchar(a)-2, nchar(a)-2) != '로')
# sum(substr(a, nchar(a), nchar(a)) == '가' & substr(a, nchar(a)-2, nchar(a)-2) == '동')
# a[(substr(a, nchar(a), nchar(a)) == '가' & substr(a, nchar(a)-2, nchar(a)-2) != '로') & !(substr(a, nchar(a), nchar(a)) == '가' & substr(a, nchar(a)-2, nchar(a)-2) == '동')]
# # 명륜이 들어간 동은 2개 밖에 없다
# sum(substr(a, 1, 2) == '명륜')
# 
# # 비상벨 데이터 '동' 처리
# # 맨 뒤에 '동' 없애기
# a <- ifelse(substr(a, nchar(a), nchar(a)) == '동', substr(a, 1, nchar(a)-1), a)
# # 명륜동 예외 처리
# a <- ifelse(substr(a, 1, 2) == '명륜', substr(a, 1, 3), a)
# # 맨 뒤에 '가' 없애고 중간에 '동' 없애기, '로' 가 들어가는 경우 '가' 만 없애기
# a <- ifelse(substr(a, nchar(a), nchar(a)) == '가', 
#             ifelse(substr(a, nchar(a)-2, nchar(a)-2) == '로',
#                    substr(a, 1, nchar(a)-1),
#                    paste0(substr(a, 1, nchar(a)-3), substr(a, nchar(a)-1, nchar(a)-1))), 
#             a)
# head(a, 200)
# 
# names(fsn2_2) <- a
# fsn2_2 <- data.frame(fsn2_2)
# fsn2_2
# ##########

# ##### 자치구 데이터 이름 맞추기 #####
# # 신사동 이름 겹침
# fsn2_sinsa <- fsn2[fsn2$LEGALDON_N=='신사동', ]
# fsn2_ggplot <- fsn2_sinsa %>% 
#   ggplot(aes(x=LA, y=LO)) +
#   geom_point() +
#   coord_quickmap()
# fsn2_ggplot
# # 경도가 127보다 작으면 관악구 신사동, 크면 강남구 신사동임.

##### 법정동 코드 #####
fsn4 <- read.csv('fsn_row4.csv', fileEncoding = "euc-kr")
fsn4 <- fsn4 %>% filter(X.1 == '') %>% select(c('법정동코드', 'X'))
# apply(fsn4, 2, as.character)
# 법정동코드 중 앞 5자리만 불러오기 
fsn4$codestr <- as.character(fsn4$법정동코드)
fsn4$codestr <- substr(fsn4$codestr, 1, 5)
##########

# ##### 비상벨 데이터 법정동 코드 정리 #####
# unique(fsn2_1$COLCT_INST)
# unique(fsn2_1$TYPE)
# fsn2_1$LEGALDON_C <- substr(as.character(fsn2_1$LEGALDON_C), 1, 5)
# ##########
# 
# ##### 비상벨 데이터와 법정동 코드 데이터 병합 #####
# fsn5 <- merge(x = fsn2_1,
#               y = fsn4,
#               by.x = 'LEGALDON_C',
#               by.y = 'codestr',
#               all.x = T)
# # left join을 한 이유는 도봉구에는 비상벨이 단 한 개도 없었기 때문이다.

# 비상벨 데이터에서 행정동 코드가 서울시로 되어있는 몇몇 데이터의 수집 위치가 
# 서울시가 아닌, 이투온으로 나와있음을 확인
# raw 데이터 상에서 법정동 코드로 병합하기로 결정함

##### 비상벨 데이터의 법정동 코드 5글자만 남기기 #####
fsn2_1$codestr <- substr(as.character(fsn2_1$LEGALDON_C), 1, 5)

# 위도, 경도가 같은 비상벨 데이터가 있을 수 있다는 의혹 제기됨 
# 좌표 값의 최소 거리인 30m안에 비상벨이 2개 있을 수 있으므로 pass

##### 비상벨 데이터와 행정동 코드 데이터 병합 및 빈도표 출력 #####
fsn2_2 <- merge(x = fsn2_1, 
                y = fsn4[,-1],
                by.x = 'codestr',
                by.y = 'codestr', 
                all.x = T)
fsn2_3 <- fsn2_2 %>% filter(TYPE == '비상벨') %>% 
  select(X) %>% 
  table() %>% 
  data.frame
names(fsn2_3) <- c('X', 'cnt_bell')

# 스마트 가로등은 특정 구에만 몰려있기 때문에 의미가 없으므로 삭제함 

##### 청소년 비행 데이터 서울특별시만 남기기 #####
##### 청소년 비행 데이터와 비상벨 빈도 데이터 병합 #####
fsn1_1 <- fsn1 %>% filter(sido == '서울특별시')
fsn <- merge(x = fsn1_1,
             y = fsn2_3,
             by.x = 'signgu',
             by.y = 'X')

fsn[is.na(fsn)] <- 0
fsn <- fsn %>% select(-c(year, sido))

##### 데이터 저장 #####
#write.csv(fsn, 'school_report_data.csv', row.names = F)




##### 메인 주제 3을 위한 전처리 #####
fsn5 <- read.csv('fsn_row1_1_utf8.csv', header = F)
names(fsn5) <- c('year', 'sido', 'signgu', 'rpt_total', 
                 'rpt_youthcrime', 'rpt_violence', 'cnt_danran', 
                 'cnt_motel', 'cnt_accm_living', 'cnt_adultgame', 
                 'cnt_bar', 'cnt_accm_travel', 'cnt_yuheung', 
                 'cnt_club')

fsn6 <- read.csv('fsn_row4_1_utf8.csv')
fsn6 <- fsn6 %>% 
  filter(폐지여부 == '존재' & (X.1 == '' | substrRight(X.1, 1) == '구') & X != '') %>% 
  select(c('법정동코드', 'X', 'X.1'))
# 법정동코드 중 앞 5자리만 불러오기 
fsn6$codestr <- as.character(fsn6$법정동코드)
fsn6$codestr <- substr(fsn6$codestr, 1, 5)
fsn6 <- fsn6 %>% select(-'법정동코드')
fsn6 <- distinct(fsn6, codestr, .keep_all = T)

##### 비상벨 데이터의 법정동 코드 5글자만 남기기 #####
fsn7 <- fsn2
fsn7$codestr <- substr(as.character(fsn7$LEGALDON_C), 1, 5)

##### 비상벨 데이터와 행정동 코드 데이터 병합 및 빈도표 출력 #####
fsn8 <- merge(x = fsn7, 
              y = fsn6,
              by.x = 'codestr',
              by.y = 'codestr', 
              all.x = T)
fsn8$X.2 <- ifelse(fsn8$X.1 == '', fsn8$X, paste(fsn8$X, fsn8$X.1))

fsn9 <- fsn8 %>% 
  select(X.2) %>% 
  table() %>% 
  data.frame()
names(fsn9) <- c('X', 'cnt_bell')

##### 청소년 비행 데이터와 비상벨 빈도 데이터 병합 #####
fsn10 <- merge(x = fsn1,
               y = fsn9,
               by.x = 'signgu',
               by.y = 'X',
               all.x = T)
fsn10[is.na(fsn10)] <- 0
fsn10 <- fsn10 %>% select(-year)

#write.csv(fsn10, 'school_report_data_korea.csv', row.names = F)
#write.csv(fsn10, 'school_report_data_korea_CP949.csv', row.names = F, fileEncoding = 'CP949')
