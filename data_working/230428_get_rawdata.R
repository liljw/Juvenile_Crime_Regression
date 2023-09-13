getwd()
setwd("/Users/kimjiewoo/R_project/data_working/")

# FSN <- read.csv("../rawdata/FSN_24_20211231_C_001.csv", header=F)
# 
# names(FSN) <- c('year', 'sido', 'signgu', 
#                 'rpt_total', 'rpt_youthcrime', 'rpt_violence', 
#                 'cnt_danran', 'cnt_motel', 'cnt_accm_living', 'cnt_adultgame', 
#                 'cnt_bar', 'cnt_accm_travel', 'cnt_yuheung', 'cnt_club')
# 
# head(FSN)

# install.packages("sf")
# install.packages("units")
# 
# library(tidyverse)
# library(sf)


# 청소년 비행 데이터
fsn_row1 <- read.csv('../rawdata/fsn_row1.csv', header = F)
names(fsn_row1) <- c('year', 'sido', 'signgu', 'rpt_total', 
                     'rpt_youthcrime', 'rpt_violence', 'cnt_danran', 
                     'cnt_motel', 'cnt_accm_living', 'cnt_adultgame', 
                     'cnt_bar', 'cnt_accm_travel', 'cnt_yuheung', 
                     'cnt_club')

# head(fsn_row1)

# # shp 파일을 불러와서 csv로 변환
# fsn_row2 <- st_read('FSN_30_20221130_G_001/FSN_30_20221130_G_001.shp')
# View(fsn_row2)
# head(fsn_row2)
# fsn_row2 <- as.data.frame(fsn_row2)
# fsn_row2 <- fsn_row2[,-7]
# write.csv(fsn_row2, 'fsn_row2.csv', row.names = F)

# 가로등 데이터 불러오기
fsn_row2 <- read.csv('../rawdata/fsn_row2.csv', header = T)

# setwd("/Users/kimjiewoo/R_project/data_working")

# head(fsn_row2)
View(fsn_row2)

# class(fsn_row2)
# 
# unique(fsn_row2$TYPE)
# 
# View(fsn_row1)

#### 230502 

# head(fsn_row1)
# head(fsn_row2)
# 
# unique(fsn_row1$sido)
# unique(fsn_row2$COLCT_INST)
# 
# V_seoul <- fsn_row1 %>% filter(sido=="서울특별시")
# View(V_seoul)
# 
# 
# B_seoul <- fsn_row2 %>% filter(COLCT_INST=="서울시")
# View(B_seoul)
# head(B_seoul)
# 
# sigungudong <- read.csv('../rawdata/sigungudong_20230502151612.csv', header = F)
# head(sigungudong)
# 
# sigungudong_rm <- sigungudong %>% filter(V2 != "소계" & V3 != "소계")
# View(sigungudong_rm)
# head(sigungudong_rm)
# 
# temp <- B_seoul %>% filter("동" %in% LEGALDON_N) # 이건 안되는듯...?
# temp <- str_detect("동")
# 
# B_seoul_temp1 <- B_seoul %>% mutate(is_dong=ifelse(str_detect(LEGALDON_N, "동"),T,F),
#                                     rm_dong=substr(LEGALDON_N,1,2))
# head(B_seoul_temp1)
#                                     
# idx <- which(str_detect(sigungudong_rm$V3, B_seoul_temp1$rm_dong))
# 
# which_sigungu <- function(string){
#   B_seoul %>% select(LEGALDON_N) %>% if(str_detect("동")){
#     temp <- substr(1, "동")
#     idx <- grep(temp, sigungudong_rm$V3)
#     sigungu <- sigungudong_rm[idx, "V2"]
#     
#   }
# }
# 
# 
# ### 230503
# 
# head(sigungudong_rm)
# head(B_seoul)
# 
# # 1. B_seoul$LEGALDON_N 의 앞 두 글자만 가져온다. 
# # 2. 위에서 추출한 두 글자가 sigungudong_rm의 V3에 속해있는지 여부 확인,
# # 3. 속해있다면 해당 데이터(sigungudong)의 인덱스 추출
# # 4. True일 경우 B_seoul에 gu라는 파생변수 생성, sigungudong의 인덱스를 이용해 V2의 값을 파생변수에 할당한다. 
# 
# substr(B_seoul$LEGALDON_N[1], 1, 2)
# 
# idx <- grep("성내", sigungudong_rm$V3)
# 
# sigungudong_rm[idx[1],2]
# 
# for (i in 1:nrow(B_seoul)) {
#   name_dong <- substr(B_seoul$LEGALDON_N[i],1,2)
#   idx <- grep(name_dong, sigungudong_rm$V3)
#   if (length(idx)>0) {
#     name_gu <- sigungudong_rm[idx[1],2]
#     B_seoul$gu[i] <- name_gu
#   }
# }
# 
# unique(B_seoul$LEGALDON_N)
# 
# View(B_seoul)
# table(B_seoul$gu)
# 
# idx_na <- which(is.na(B_seoul$gu))
# data_na <- B_seoul[idx_na, c("LEGALDON_N","gu")]
# data_na
# 
# View(sigungudong_rm)
# unique(data_na$LEGALDON_N)
# 
# subset(B_seoul, B_seoul$LEGALDON_N=="신사동")
# 
# 
# sort_sigungudong <- sort(sigungudong_rm$V3)
# sort_b <- sort(B_seoul$LEGALDON_N)
# 
# length(unique(sort_sigungudong))
# length(unique(sort_b))
# 
# 
# ########## 230504
# 
# getwd()
# 
# setwd("/Users/kimjiewoo/R_project/data_working")
# 
# 
# rm(list=ls())
# 
local_code <- read.csv("../rawdata/local_code/local_code_download_utf8.csv")

local_code_gu <- local_code %>% filter(X.1=="") %>% select("법정동코드", "X")

## 문자열로 바꾸기

local_code_gu <- apply(local_code_gu,2,as.character)

local_code_gu[,"법정동코드"] <- substr(local_code_gu[,"법정동코드"],1,5)
# 
# B_seoul <- B_seoul %>% select(COLCT_INST, TYPE, LEGALDON_C, LEGALDON_N)
# 
# B_seoul[,"LEGALDON_C"] <- substr(B_seoul[,"LEGALDON_C"],1,5)
# 
# str(B_seoul)

# for (i in 1:nrow(B_seoul)) {
#   if (B_seoul[i,"LEGALDON_C"] %in% local_code_gu[,"법정동코드"] == T) {
#     
#   }
# }

# fsn5 <- merge(B_seoul, local_code_gu, by.x="LEGALDON_C", by.y="법정동코드", all.x=T)
# 
# str(fsn5)

# merge() 함수 적용 시, outer join (all=T)를 했을 때, 관측값이 하나가 더 추가 되었는데,  
# 어떤 행정구역 코드에 해당하는 법정동이 비상벨 데이터에는 없을 수도 있다. (도봉구) 
# 따라서 그 구는 NA값으로 결측값이 들어간 행(관측값)이 하나 추가된다.

### 도봉구의 데이터가 서울시에 포함되는게 아니라 "이투온"에 포함되는 것 확인. 
## 기존의 rawdata를 다시 가져와서 이번에는 서울특별시로 filter하지않고

fsn_row2 <- fsn_row2 %>% select(COLCT_INST, TYPE, LEGALDON_C, LEGALDON_N)

fsn_row2[,"LEGALDON_C"] <- substr(fsn_row2[,"LEGALDON_C"],1,5)

fsn5 <- merge(fsn_row2, local_code_gu, by.x="LEGALDON_C", by.y="법정동코드", all.x=T)

str(fsn_row2)
str(fsn5)

# View(fsn5)

## 위도 경도 확인


var1 <- table(fsn_row2$LA) > 1

var1 <- var1[var1==T]

names_var1 <- names(var1)

library(tidyverse)

fsn_row2 %>% filter(LA==names_var1[1])
fsn_row2 %>% filter(LA==names_var1[2])
fsn_row2 %>% filter(LA==names_var1[3])
fsn_row2 %>% filter(LA==names_var1[4])
fsn_row2 %>% filter(LA==names_var1[5])
fsn_row2 %>% filter(LA==names_var1[6])
fsn_row2 %>% filter(LA==names_var1[7])
fsn_row2 %>% filter(LA==names_var1[8])
fsn_row2 %>% filter(LA==names_var1[9])
fsn_row2 %>% filter(LA==names_var1[10])

## 230508

# head(fsn5)

fsn6 <- data.frame(table(fsn5$X))

# View(fsn_row2)
# 
# nrow(fsn_row2[fsn_row2$LEGALDON_C=="11305",])

table(fsn5_rm$TYPE)

fsn5_rm <- na.omit(fsn5)

# 스마트가로등은 안쓰기로 함
garodeung <- fsn5_rm[fsn5_rm$TYPE=="스마트가로등",]
View(garodeung)

# 비상벨 데이터만 쓰기로 함 -> 정제
Bisangbell <- fsn5_rm[fsn5_rm$TYPE=="비상벨",]

str(Bisangbell)
# View(Bisangbell)

# 구 별 집계된 데이터 따로 데이터셋에 저장
Bisangbell_table <- data.frame(table(Bisangbell$X))
names(Bisangbell_table) <- c("Var1", "cnt_bell")

# fsn_row1 (학교폭력 rawdata) 를 서울특별시만 필터링
View(fsn_row1)

fsn1_seoul <- fsn_row1[fsn_row1$sido=="서울특별시",]

nrow(fsn1_seoul)

fsn7 <- merge(fsn1_seoul, Bisangbell_table, by.x="signgu", by.y="Var1", all.x=T)

View(fsn7)

# 최종 데이터 셋 정제 
# NA값은 0으로 처리.

fsn7[is.na(fsn7)] <- 0

# fsn7 <- mutate_all(fsn7, ~replace(., is.na(.), 0))

## 최종 데이터셋 파일 저장

fsn7 <- fsn7 %>% select(-sido, -year)
View(fsn7)
write.csv(fsn7, "../rawdata/최종데이터/school_report_data.csv", row.names=F)



##### 230511 주제 추가

View(fsn_row1)

fsn1 <- fsn_row1 %>% select(-cnt_motel, -cnt_accm_living, -cnt_accm_travel)

fsn1[is.na(fsn1)] <- 0

View(fsn1)

## 유흥 시설 개수가 많을 수록 비행 / 학교폭력 신고 수가 많을 것이다.

lm3_2 <- lm(rpt_youthcrime ~ cnt_danran + cnt_adultgame + cnt_bar + cnt_yuheung + cnt_club, fsn1)

lm3_2 <- step(lm3_2, direction="both")

summary(lm3_2)


###

lm3_2_2 <- lm(rpt_violence ~ cnt_danran + cnt_adultgame + cnt_bar + cnt_yuheung + cnt_club, fsn1)

lm3_2_2 <- step(lm3_2_2, direction="both")

summary(lm3_2_2)

### 정규화

fsn1_norm <- fsn1 %>% select(cnt_danran, cnt_adultgame, cnt_bar, cnt_yuheung, cnt_club) %>% preProcess(method=c("range"))

fsn1_norm <- predict(fsn1_norm, fsn1)

lm_t <- lm(rpt_violence ~ cnt_danran + cnt_adultgame + cnt_bar + cnt_yuheung + cnt_club, fsn1_norm)

lm_t <- step(lm_t, direction="both")

summary(lm_t)


## 유흥 ~ 비상벨 전국

View(fsn_row1)
fsn_row1[is.na(fsn_row1)] <- 0

fsn_row1$cnt_total <- apply(fsn_row1[,7:14], 1, sum)

# 유흥시설 개수가 많으면 비상벨 개수가 많을 것 이다. 
lm5 <- lm(fsn_row1$cnt_total ~ fsn_row1$, SRD)
summary(lm4)

boxplot(fsn_row1$cnt_total)
boxplot(SRD$cnt_total)

head(sort(SRD$cnt_total),20)

shapiro.test(head(sort(SRD$cnt_total),23))

qqnorm(SRD$cnt_total)
qqline(SRD$cnt_total, col="red")

## 전국

fsn_row5 <- read.csv('../rawdata/local_code/local_code_jeonguk_utf8.csv', header = T)

class(fsn_row5)
View(fsn_row5)
View(fsn_row2)

fsn_row5 <- fsn_row5 %>% select(-X.3, -X.2) %>% filter(폐지여부=="존재")

fsn_row5 <- apply(fsn_row5,2,as.character)

fsn_row5[,"법정동코드"] <- substr(fsn_row5[,"법정동코드"],1,5)

###

fsn_row2 <- fsn_row2 %>% select(COLCT_INST, TYPE, LEGALDON_C, LEGALDON_N)
fsn_row2 <- apply(fsn_row2,2,as.character)
fsn_row2[,"LEGALDON_C"] <- substr(fsn_row2[,"LEGALDON_C"],1,5)


fsn_row5 <- fsn_row5 %>% as.data.frame() %>% select(-폐지여부)



fsn_j <- merge(fsn_row2, fsn_row5, by.x="LEGALDON_C", by.y="법정동코드", all.x=T)

View(fsn_j)
