#Read in files
USMX_autoscore <- read_excel("/Users/sarahpaull/Desktop/Creel-Lab/USMX_autoscore.xlsx")
USMX_autoscore_5 <- read_excel("/Users/sarahpaull/Desktop/Creel-Lab/USMX_autoscore_5.xlsx")

#Change column names
colnames(USMX_autoscore_5)[which(colnames(USMX_autoscore_5) == "pwc")] <- "pwc_5"
colnames(USMX_autoscore_5)[which(colnames(USMX_autoscore_5) == "autoscore")] <- "autoscore_5"

#Combine Dataframes
USMX_both <- USMX_autoscore
USMX_both$pwc_5 <- USMX_autoscore_5$pwc_5
USMX_both$autoscore_5 <- USMX_autoscore_5$autoscore_5
new_order <- c("id", "file", "response", "target", "autoscore", "autoscore_5", "pwc", "pwc_5")
USMX_both <- USMX_both[, new_order]

#Dummy variable to see if pwc is the same on the two different autoscore functions (0 is same 1 is different)
USMX_both$pwc_comparison <- ifelse(USMX_both$pwc == USMX_both$pwc_5, 0, 1)

