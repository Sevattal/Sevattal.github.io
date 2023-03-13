DROP PROCEDURE htmlReport8;
CREATE PROCEDURE htmlReport8(
IN orderCode VARCHAR(255),
OUT pReturn TEXT
)
BEGIN
	-- 委托单位
	DECLARE client VARCHAR(255);
	-- 联系人
	DECLARE contact VARCHAR(255);
	-- 地址
	DECLARE address VARCHAR(255);
	-- 联系方式
	DECLARE contactNumber VARCHAR(255);
	-- 样品处理
	DECLARE productHandling VARCHAR(255);
	-- 样品处理邮寄地址
	DECLARE productPostalAddress VARCHAR(255);
	-- 报告处理
	DECLARE reportHandling VARCHAR(255);
	-- 报告处理邮寄地址
	DECLARE reportPostalAddress VARCHAR(255);
	-- 任务名称
	DECLARE taskName VARCHAR(255);
	-- 项目令号
	DECLARE projectNumber VARCHAR(255);
	-- 任务编号
	DECLARE taskNumber VARCHAR(255);
	-- 收料日期
	DECLARE receivedDate VARCHAR(255);
	-- 要求完成日期
	DECLARE requiredDate VARCHAR(255);
	-- 商定完成日期
	DECLARE agreedDate VARCHAR(255);

	-- 材料ID
	DECLARE materialID VARCHAR(255);
	-- 材料名称
	DECLARE material VARCHAR(255);
	-- 牌号
	DECLARE grades VARCHAR(255);
	-- 材料规格
	DECLARE thicknessDiameter VARCHAR(255);
	-- 材料热处理状态
	DECLARE heatCondition VARCHAR(255);
	-- 成型工艺
	DECLARE process VARCHAR(255);
	-- 材料炉批号
	DECLARE batchNo VARCHAR(255);
	-- 试样类型
	DECLARE materialType VARCHAR(255);
	-- 试样数量
	DECLARE quantity VARCHAR(255);
	-- 试样尺寸
	DECLARE dimension VARCHAR(255);
	-- 试样编号
	DECLARE specimenNumber VARCHAR(255);

	-- 材料是否存在
	DECLARE countMaterial INT;

	-- 检测项目
	DECLARE testItem VARCHAR(255);
	-- 检测标准
	DECLARE testStandard VARCHAR(255);
	-- 加载参数
	DECLARE loadParameter VARCHAR(255);
	-- 试验环境
	DECLARE environment VARCHAR(255);

	-- 拼接部分定义
	-- 存放HTML
	DECLARE htmlMain TEXT DEFAULT '';
	-- 存放HTML拼接的订单前半部分
	DECLARE htmlOrder1 TEXT DEFAULT '';
	-- 存放材料、任务要求部分
	DECLARE htmlOrder2 TEXT DEFAULT '';
	-- 存放后半部分
	DECLARE htmlOrder3 TEXT DEFAULT '';

	-- 材料表游标
	DECLARE done INT DEFAULT 0;

	DECLARE cur_1 CURSOR FOR
	SELECT IFNULL(SKF137, ''), IFNULL(SKF138, ''), IFNULL(SKF139, ''),
	IFNULL(SKF140, ''), IFNULL(SKF143, ''), IFNULL(SKF278, ''),
	IFNULL(SKF142, ''), IFNULL(SKF279, ''), IFNULL(SKF150, ''), 
	IFNULL(SKF148, ''), IFNULL(SKF280, '')
	FROM SKT9 WHERE SKF362 = orderCode AND SKF524 != 1;

	DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = 1;

	-- 获取报告的基础信息
	SELECT IFNULL(SKF69, ''), IFNULL(SKF71, ''), IFNULL(SKF70, ''), IFNULL(SKF72, ''),
	IFNULL(SKF73, ''), IFNULL(SKF74, ''),IFNULL(SKF75, ''), IFNULL(SKF76, ''),
	IFNULL(SKF77, ''), IFNULL(SKF78, ''), IFNULL(SKF79, ''), IFNULL(SKF80, ''),
	IFNULL(SKF81, ''), IFNULL(SKF82, '')  INTO 
	client, contact, address, contactNumber,  
	productHandling, productPostalAddress,reportHandling,reportPostalAddress,
	taskName, projectNumber, taskNumber, receivedDate, 
	requiredDate, agreedDate
	FROM SKT8 WHERE SKF68 = orderCode;

	SET htmlOrder1 = 
	CONCAT(
		'<!DOCTYPE html>
		<html>
		<head>
			<meta charset="gb2312">
			<title>腐蚀与环境性能检测委托</title>
			<style type="text/css">
				body{
					font-size: 14px;
					text-align: center;
				}
				table{
					width: 100%;
				}
				.td_1_checkbox{
					width: 25%;
				}
				.table_1_checkbox{
					font-size: 12px;
				}
				.table_NoTopBorder{
					border-top: 0px;
				}
			</style>

		</head>
		<body>
			<table border="1" cellpadding="0" cellspacing="0">
				<tbody>
					<tr>
						<td style="width: 20%;">委托单位<br>Client</td>
						<td style="width: 40%;">',client ,'</td>
						<td style="width: 20%;">联系人<br>Contact</td>
						<td>',contact ,'</td>
					</tr>
					<tr>
						<td>地址<br>Address</td>
						<td>',address ,'</td>
						<td>联系方式<br>Contact Number</td>
						<td>',contactNumber ,'</td>
					</tr>');

	IF productHandling = '委托处理' THEN
		SET htmlOrder1 = 
		CONCAT(htmlOrder1,
				'<tr>
				<td class="td_top1_1" style="width: 20%">样品处理<br>Handling of Specimens</td>
				<td colspan="3">
					<table class="table_1_checkbox">
						<tbody>
							<tr>
								<td class="td_1_checkbox"><input type="checkbox" disabled="disabled" name="委托处理" value="委托处理" checked="checked">委托处理<br>Commissioned Handling</td>
								<td class="td_1_checkbox"><input type="checkbox" disabled="disabled" name="自取" value="自取">自取<br>Self-pick up</td>
								<td><input type="checkbox" disabled="disabled" name="邮寄（邮寄地址）" value="邮寄（邮寄地址）">邮寄（邮寄地址）<br>Post (Postal Address)</td>
							</tr>
						</tbody>
					</table>
				</td>
			</tr>');
	ELSEIF productHandling = '自取' THEN
		SET htmlOrder1 = 
		CONCAT(htmlOrder1,
				'<tr>
				<td class="td_top1_1" style="width: 20%">样品处理<br>Handling of Specimens</td>
				<td colspan="3">
					<table class="table_1_checkbox">
						<tbody>
							<tr>
								<td class="td_1_checkbox"><input type="checkbox" disabled="disabled" name="委托处理" value="委托处理">委托处理<br>Commissioned Handling</td>
								<td class="td_1_checkbox"><input type="checkbox" disabled="disabled" name="自取" value="自取" checked="checked">自取<br>Self-pick up</td>
								<td><input type="checkbox" disabled="disabled" name="邮寄（邮寄地址）" value="邮寄（邮寄地址）">邮寄（邮寄地址）<br>Post (Postal Address)</td>
							</tr>
						</tbody>
					</table>
				</td>
			</tr>');
	ELSEIF productHandling = '邮寄' THEN
		SET htmlOrder1 = 
		CONCAT(htmlOrder1,
				'<tr>
				<td class="td_top1_1" style="width: 20%">样品处理<br>Handling of Specimens</td>
				<td colspan="3">
					<table class="table_1_checkbox">
						<tbody>
							<tr>
								<td class="td_1_checkbox"><input type="checkbox" disabled="disabled" name="委托处理" value="委托处理">委托处理<br>Commissioned Handling</td>
								<td class="td_1_checkbox"><input type="checkbox" disabled="disabled" name="自取" value="自取">自取<br>Self-pick up</td>
								<td><input type="checkbox" disabled="disabled" name="邮寄（邮寄地址）" value="邮寄（邮寄地址）" checked="checked">邮寄（邮寄地址）',productPostalAddress,'<br>Post (Postal Address)</td>
							</tr>
						</tbody>
					</table>
				</td>
			</tr>');
	ELSE
		SET htmlOrder1 = 
		CONCAT(htmlOrder1,
				'<tr>
				<td class="td_top1_1" style="width: 20%">样品处理<br>Handling of Specimens</td>
				<td colspan="3">
					<table class="table_1_checkbox">
						<tbody>
							<tr>
								<td class="td_1_checkbox"><input type="checkbox" disabled="disabled" name="委托处理" value="委托处理">委托处理<br>Commissioned Handling</td>
								<td class="td_1_checkbox"><input type="checkbox" disabled="disabled" name="自取" value="自取">自取<br>Self-pick up</td>
								<td><input type="checkbox" disabled="disabled" name="邮寄（邮寄地址）" value="邮寄（邮寄地址）">邮寄（邮寄地址）<br>Post (Postal Address)</td>
							</tr>
						</tbody>
					</table>
				</td>
			</tr>');
	END IF;

	IF reportHandling = '自取' THEN
		SET htmlOrder1 = 
		CONCAT(htmlOrder1,
			'	<tr>
					<td>取报告方式<br>Report pick up</td>
					<td colspan="3">
						<table class="table_1_checkbox">
							<tbody>
								<tr>
									<td class="td_1_checkbox"><input type="checkbox" disabled="disabled" name="自取" value="自取" checked="checked">自取<br>Self-pick up</td>
									<td class="td_1_checkbox"><input type="checkbox" disabled="disabled" name="传真（号码）" value="传真（号码）">传真（号码）<br>Fax（Number）</td>
									<td><input type="checkbox" disabled="disabled" name="邮寄（邮寄地址）" value="邮寄（邮寄地址）">邮寄（邮寄地址）<br>Post (Postal Address)</td>
								</tr>
							</tbody>
						</table>
					</td>
				</tr>
			</tbody>
		</table>');
	ELSEIF reportHandling = '传真' THEN
		SET htmlOrder1 = 
		CONCAT(htmlOrder1,
			'	<tr>
					<td>取报告方式<br>Report pick up</td>
					<td colspan="3">
						<table class="table_1_checkbox">
							<tbody>
								<tr>
									<td class="td_1_checkbox"><input type="checkbox" disabled="disabled" name="自取" value="自取">自取<br>Self-pick up</td>
									<td class="td_1_checkbox"><input type="checkbox" disabled="disabled" name="传真（号码）" value="传真（号码）" checked="checked">传真（号码）<br>Fax（Number）</td>
									<td><input type="checkbox" disabled="disabled" name="邮寄（邮寄地址）" value="邮寄（邮寄地址）">邮寄（邮寄地址）<br>Post (Postal Address)</td>
								</tr>
							</tbody>
						</table>
					</td>
				</tr>
			</tbody>
		</table>');
	ELSEIF reportHandling = '邮寄' THEN
		SET htmlOrder1 = 
		CONCAT(htmlOrder1,
			'	<tr>
					<td>取报告方式<br>Report pick up</td>
					<td colspan="3">
						<table class="table_1_checkbox">
							<tbody>
								<tr>
									<td class="td_1_checkbox"><input type="checkbox" disabled="disabled" name="自取" value="自取">自取<br>Self-pick up</td>
									<td class="td_1_checkbox"><input type="checkbox" disabled="disabled" name="传真（号码）" value="传真（号码）">传真（号码）<br>Fax（Number）</td>
									<td><input type="checkbox" disabled="disabled" name="邮寄（邮寄地址）" value="邮寄（邮寄地址）"  checked="checked">邮寄（邮寄地址）',reportPostalAddress,'<br>Post (Postal Address)</td>
								</tr>
							</tbody>
						</table>
					</td>
				</tr>
			</tbody>
		</table>');
	ELSE
		SET htmlOrder1 = 
		CONCAT(htmlOrder1,
			'	<tr>
					<td>取报告方式<br>Report pick up</td>
					<td colspan="3">
						<table class="table_1_checkbox">
							<tbody>
								<tr>
									<td class="td_1_checkbox"><input type="checkbox" disabled="disabled" name="自取" value="自取">自取<br>Self-pick up</td>
									<td class="td_1_checkbox"><input type="checkbox" disabled="disabled" name="传真（号码）" value="传真（号码）">传真（号码）<br>Fax（Number）</td>
									<td><input type="checkbox" disabled="disabled" name="邮寄（邮寄地址）" value="邮寄（邮寄地址）">邮寄（邮寄地址）<br>Post (Postal Address)</td>
								</tr>
							</tbody>
						</table>
					</td>
				</tr>
			</tbody>
		</table>');
	END IF;

	SET htmlOrder1 = 
	CONCAT(htmlOrder1,
	'	<table class="table_NoTopBorder" border="1" cellpadding="0" cellspacing="0">
			<tbody>
				<tr>
					<td style="width: 20%;">任务名称<br>Task Name</td>
					<td style="width: 13%;">',taskName,'</td>
					<td style="width: 20%;">项目令号<br>Project Number</td>
					<td style="width: 13%;">',projectNumber,'</td>
					<td style="width: 20%;">任务编号<br>Task Number</td>
					<td>',taskNumber,'</td>
				</tr>
				<tr>
					<td>收样日期<br>Received Date</td>
					<td>',receivedDate,'</td>
					<td>要求完成日期<br>Required Date</td>
					<td>',requiredDate,'</td>
					<td>商定完成日期<br>Agreed Date</td>
					<td>',agreedDate,'</td>
				</tr>
			</tbody>
		</table>');

	-- 判断材料表是否存在
	SELECT COUNT(SKF137) INTO countMaterial FROM SKT9 WHERE SKF362 = orderCode AND SKF524 != 1;

	IF countMaterial > 0 THEN
		OPEN cur_1;
		FETCH cur_1 INTO materialID ,material ,grades ,thicknessDiameter ,heatCondition ,process ,
		batchNo ,materialType ,quantity ,dimension ,specimenNumber ;
		WHILE done != 1 DO
			SET htmlOrder2 = 
			CONCAT(htmlOrder2,
			'<table class="table_NoTopBorder" border="1" cellpadding="0" cellspacing="0">
				<tbody>
					<tr>
						<td style="width: 20%;"  rowspan="4">试样信息<br>Material</td>
						<td style="width: 20%;">材料名称/牌号<br>Material/Grades</td>
						<td style="width: 20%;">',material,'/',grades,'</td>
						<td style="width: 20%;">材料规格<br>Thickness or Diameter</td>
						<td>',thicknessDiameter,'</td>
					</tr>
					<tr>
						<td>材料热处理状态/成型工艺<br>Heat Condition/Process</td>
						<td>',heatCondition,'/',process,'</td>
						<td>材料炉批号<br>Heat No./Batch No.</td>
						<td>',batchNo,'</td>
					</tr>
					<tr>
						<td>试样类型<br>Type</td>
						<td>',materialType,'</td>
						<td>试样数量<br>Quantity</td>
						<td>',quantity,'</td>				
					</tr>
					<tr>
						<td>试样尺寸<br>Dimension</td>
						<td>',dimension,'</td>
						<td>试样编号<br>Specimen Number</td>
						<td>',specimenNumber,'</td>
					</tr>
				</tbody>
			</table>');

			-- 获取任务表信息
			SELECT IFNULL(GROUP_CONCAT(SKF175),''), IFNULL(GROUP_CONCAT(SKF174), ''),
			IFNULL(GROUP_CONCAT(SKF187), ''), IFNULL(GROUP_CONCAT(SKF173) , '')
			INTO testItem, testStandard,loadParameter,environment
			FROM SKT10 WHERE SKF388 = materialID;

			SET htmlOrder2 = 
			CONCAT(htmlOrder2,
				'<table class="table_NoTopBorder" border="1" cellpadding="0" cellspacing="0">
					<tbody>
						<tr>
							<td style="width: 20%;" rowspan="2">任务要求<br>Task</td>
							<td>
								试验及技术要求（检测项目, 检测标准, 加载参数, 试验环境等）<br>
								Test and Technical Requirements (Testing Item, Standard, Loading Parameters, Environment etc.)
							</td>
						</tr>
						<tr>
							<td style="height: 85px; text-align: left">
							检测项目：',testItem,'<br>
							检测标准：',testStandard,'<br>
							加载参数：',loadParameter,'<br>
							试验环境：',environment,'<br>
							</td>
						</tr>
					</tbody>
				</table>');
			FETCH cur_1 INTO materialID ,material ,grades ,thicknessDiameter ,heatCondition ,process ,
			batchNo ,materialType ,quantity ,dimension ,specimenNumber ;
		END WHILE;
	ELSE
		SET htmlOrder2 =
		'	<table class="table_NoTopBorder" border="1" cellpadding="0" cellspacing="0">
				<tbody>
					<tr>
						<td style="width: 20%;"  rowspan="4">试样信息<br>Material</td>
						<td style="width: 20%;">材料名称/牌号<br>Material/Grades</td>
						<td style="width: 20%;"></td>
						<td style="width: 20%;">材料规格<br>Thickness or Diameter</td>
						<td></td>
					</tr>
					<tr>
						<td>材料热处理状态/成型工艺<br>Heat Condition/Process</td>
						<td></td>
						<td>材料炉批号<br>Heat No./Batch No.</td>
						<td></td>
					</tr>
					<tr>
						<td>试样类型<br>Type</td>
						<td></td>
						<td>试样数量<br>Quantity</td>
						<td></td>				
					</tr>
					<tr>
						<td>试样尺寸<br>Dimension</td>
						<td></td>
						<td>试样编号<br>Specimen Number</td>
						<td></td>
					</tr>
				</tbody>
			</table>
			
			<table class="table_NoTopBorder" border="1" cellpadding="0" cellspacing="0">
				<tbody>
					<tr>
						<td style="width: 20%;" rowspan="2">任务要求<br>Task</td>
						<td>
							试验及技术要求（检测项目, 检测标准, 加载参数, 试验环境等）<br>
							Test and Technical Requirements (Testing Item, Standard, Loading Parameters, Environment etc.)
						</td>
					</tr>
					<tr>
						<td style="height: 85px;"></td>
					</tr>
				</tbody>
			</table>';
	END IF;
	SET htmlOrder3 = 
	'		<table class="table_NoTopBorder" border="1" cellpadding="0" cellspacing="0">
			<tbody>
				<tr>
					<td style="text-align: left;" colspan="2">
						委托单位代表 Client：<br>
						签字 Signature：<br>
						日期 Date：
					</td>
				</tr>
				<tr>
					<td style="text-align: left;" colspan="2">
						承制单位代表 Undertaking Unit：<br>
						签字 Signature：<br>
						日期 Date：
					</td>
				</tr>
				<tr>
					<td style="width: 10%;">
						承诺<br>
						Promise
					</td>
					<td style="text-align: left;">
						委托单位保证对所提供的一切资料、实物的真实性负责。<br>
						本公司保证检测的公正性，对检测数据负责，对委托单位所提供的技术资料保密。<br>
						The client should be responsible for the truth of all documents and objects provided.
						Our company guarantees the impartiality of the test, responsible for the accuracy of testing data and confidentiality of technical information provided by the client.
					</td>
				</tr>
			</tbody>
		</table>
	</body>
	</html>';

	-- 开始拼接最终HTML页面
	SET htmlMain = CONCAT(htmlOrder1,htmlOrder2,htmlOrder3);
	-- 插入到html表
	START TRANSACTION;
		IF htmlMain IS NOT NULL AND htmlMain  != '' THEN
			DELETE FROM SKT32 WHERE SKF571 = orderCode;
			INSERT INTO SKT32 (SKF571, SKF572) VALUE (orderCode, htmlMain);
			SET pReturn = 1;
		ELSE
			-- 设置返回值为0
			SET pReturn = 0;
		END IF;
	COMMIT;
END;