-- DROP PROCEDURE htmlOrder6;
CREATE PROCEDURE htmlOrder6(
IN orderCode VARCHAR(255),
OUT pReturn TEXT
)
BEGIN
	-- 委托单位Client
	DECLARE client VARCHAR(255);
	-- 联系人
	DECLARE contact VARCHAR(255);
	-- 单位地址
	DECLARE address VARCHAR(255);
	-- 联系方式
	DECLARE contactInformation VARCHAR(255);
	-- 样品处理
	DECLARE handlingSpecimens VARCHAR(255);
	-- 样品处理邮寄地址
	DECLARE handlingPostalAddress VARCHAR(255);
	-- 取报告方式
	DECLARE reportPickUp VARCHAR(255);
	-- 取报告邮寄地址
	DECLARE reportPostalAddress VARCHAR(255);
	-- 任务名称
	DECLARE taskName VARCHAR(255);
	-- 项目令号
	DECLARE projectNumber VARCHAR(255);
	-- 任务编号
	DECLARE taskNumber VARCHAR(255);
	-- 收样日期
	DECLARE receivedDate VARCHAR(255);
	-- 要求完成日期
	DECLARE finishDate VARCHAR(255);
	-- 商定完成日期
	DECLARE agreedDate VARCHAR(255);


	-- 材料表信息
	-- 材料ID
	DECLARE eutID VARCHAR(255);
	-- 试样名称
	DECLARE eutName VARCHAR(255);
	-- 试样数量
	DECLARE eutNumber VARCHAR(255);
	-- 型号/规格
	DECLARE modelType VARCHAR(255);
	-- 试样编号
	DECLARE eutNo VARCHAR(255);
	-- 检测依据
	DECLARE testStandard VARCHAR(255);
	-- 夹具信息
	DECLARE fixtureInformation VARCHAR(255);

	-- 任务要求
	-- 检测目的
	DECLARE testAim VARCHAR(255);
	-- 检测项目
	DECLARE testItem VARCHAR(255);
	-- 检测方法/条件
	DECLARE testMethod VARCHAR(255);
	-- 合格判断
	DECLARE criteriaConformity VARCHAR(255);
	-- 其他
	DECLARE taskRequirements VARCHAR(255);

	-- 判断材料样品是否存在
	DECLARE countMaterial INT;

	-- 拼接部分定义
	-- 存放HTML
	DECLARE htmlMain TEXT DEFAULT '';
	-- 存放HTML拼接的订单前半部分
	DECLARE htmlOrder1 TEXT DEFAULT '';
	-- 存放材料、任务要求部分
	DECLARE htmlOrder2 TEXT DEFAULT '';
	-- 存放后半部分
	DECLARE htmlOrder3 TEXT DEFAULT '';

	-- 材料信息表游标
	DECLARE done INT DEFAULT 0;
	DECLARE cur_1 CURSOR FOR
	SELECT IFNULL(SKF137, ''), IFNULL(SKF138, ''),IFNULL(SKF150,''),
	IFNULL(SKF140, ''), IFNULL(SKF280, ''), IFNULL(SKF426, ''),
	IFNULL(SKF425, '') 
	FROM SKT9 WHERE SKF362 = orderCode AND SKF524 != 1;

	DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = 1;

	-- 主表信息赋值
	SELECT IFNULL(SKF69,''), IFNULL(SKF71,''),IFNULL(SKF70, ''), IFNULL(SKF72, ''),
	IFNULL(SKF73,''), IFNULL(SKF74, ''), IFNULL(SKF75, ''), IFNULL(SKF76, ''),
	IFNULL(SKF77,''), IFNULL(SKF78, ''), IFNULL(SKF79, ''), IFNULL(SKF80, ''),
	IFNULL(SKF81, ''), IFNULL(SKF82, '') INTO 
	client, contact, address, contactInformation, 
	handlingSpecimens, handlingPostalAddress, reportPickUp,reportPostalAddress, 
	taskName, projectNumber, taskNumber, receivedDate, 
	finishDate, agreedDate FROM SKT8 WHERE SKF68 = orderCode;

	SET htmlORder1 =
	CONCAT(
	'<!DOCTYPE html>
	<html>
	<head>
		<meta charset="utf-8">
		<title>振动可靠性检测委托单</title>
		<style type="text/css">
			div{
				width: 100%;
				border: 1px solid #220808;
			}
			table {
				width: 100%;
				border: 0px;

			}
			td {
				border-right: 1px solid #220808;
				border-top: 1px solid #220808;
				border-left: 0px;
				border-bottom: 0px;
				height: 50px;
				text-align: center;
			}
			.td_rigth{
				border-right: 0px;
				border-top: 1px solid #220808;
				border-left: 0px;
				border-bottom: 0px;
			}
			.td_rigth3_1{
				border-right: 0px;
				border-top: 1px solid #220808;
				border-left: 0px;
				border-bottom: 0px;
				height: 50px;
				text-align: left;
			}

			.td_top1_1{
				border-right: 1px solid #220808;
				border-top: 0px;
				border-left: 0px;
				border-bottom: 0px;
				text-align: center;
			}
			.td_top_right1_1{
				border-left: 0px;
				border-bottom: 0px;
				border-top: 0px; 
				border-right: 0px;
			}
			.td_hide_border1{
				border-top: 0px;
				border-bottom: 0px;
				border-right: 0px;
				border-left: 0px;
				text-align: center;
			}
			.td_hide_border2{
				border-top: 1px solid #220808;
				border-bottom: 0px;
				border-right: 0px;
				border-left: 0px;
				text-align: center;
			}
			.td_top1_2{
				border-right: 1px solid #220808;
				border-top: 0px;
				border-left: 0px;
				border-bottom: 0px;
				text-align: center;
				width: 16%;
			}
			.td_top_right1_2{
				border-left: 0px;
				border-bottom: 0px;
				border-top: 0px; 
				border-right: 0px;
				text-align: center;
				width: 16%;
			}
			.div_in{
				border-top: 0px;
				border-bottom: 0px;
				border-left: 0px;
				border-right: 0px;
			}
			.td_top2_1{
				border-right: 1px solid #220808;
				border-top: 0px;
				border-left: 0px;
				border-bottom: 0px;
				text-align: center;
				width: 20%;
			}
			.td_top_right2_1{
				border-left: 0px;
				border-bottom: 0px;
				border-top: 0px; 
				border-right: 0px;
				text-align: center;
				width: 20%;
			}
		</style>
	</head>
	<body>
		<div>
			<!-- cellpadding="0" cellspacing="0" 用于解决表格中的空袭 -->
			<table cellpadding="0" cellspacing="0">
				<tbody>
					<tr>
						<td class="td_top1_1" style="width: 20%;">委托单位<br>Client</td>
						<td class="td_top1_1" style="width: 40%;">',client,'</td>
						<td class="td_top1_1" style="width: 20%;">联系人<br>Contact</td>
						<td class="td_top_right1_1" style="width: 20%;">',contact,'</td>
					</tr>
					<tr>
						<td>地址<br>Address</td>
						<td>',address,'</td>
						<td>联系方式<br>Contact Number</td>
						<td class="td_rigth">',contactInformation,'</td>
					</tr>
				</tbody>
			</table>
		</div>');

	IF  handlingSpecimens = '委托处理'  THEN
		SET htmlOrder1 = 
		CONCAT(htmlOrder1,
		'<div style="border-top: 0px;">
			<table cellpadding="0" cellspacing="0">
				<tbody>
					<tr>
						<td class="td_top1_1" style="width: 20%">样品处理<br>Handling of Specimens</td>
						<td class="td_hide_border1"><input type="checkbox" disabled="disabled" name="委托处理" value="委托处理" checked="checked">委托处理<br>Commissioned Handling</td>
						<td class="td_hide_border1"><input type="checkbox" disabled="disabled" name="自取" value="自取">自取<br>Self-pick up</td>
						<td class="td_hide_border1"><input type="checkbox" disabled="disabled" name="邮寄（邮寄地址）" value="邮寄（邮寄地址）">邮寄（邮寄地址）<br>Post (Postal Address)</td>
					</tr>');
	ELSEIF handlingSpecimens = '自取' THEN
		SET htmlOrder1 = 
		CONCAT(htmlOrder1,
		'<div style="border-top: 0px;">
			<table cellpadding="0" cellspacing="0">
				<tbody>
					<tr>
						<td class="td_top1_1" style="width: 20%">样品处理<br>Handling of Specimens</td>
						<td class="td_hide_border1"><input type="checkbox" disabled="disabled" name="委托处理" value="委托处理">委托处理<br>Commissioned Handling</td>
						<td class="td_hide_border1"><input type="checkbox" disabled="disabled" name="自取" value="自取" checked="checked">自取<br>Self-pick up</td>
						<td class="td_hide_border1"><input type="checkbox" disabled="disabled" name="邮寄（邮寄地址）" value="邮寄（邮寄地址）">邮寄（邮寄地址）<br>Post (Postal Address)</td>
					</tr>');
	ELSEIF handlingSpecimens = '邮寄' THEN
		SET htmlOrder1 = 
		CONCAT(htmlOrder1,
		'<div style="border-top: 0px;">
			<table cellpadding="0" cellspacing="0">
				<tbody>
					<tr>
						<td class="td_top1_1" style="width: 20%">样品处理<br>Handling of Specimens</td>
						<td class="td_hide_border1"><input type="checkbox" disabled="disabled" name="委托处理" value="委托处理">委托处理<br>Commissioned Handling</td>
						<td class="td_hide_border1"><input type="checkbox" disabled="disabled" name="自取" value="自取">自取<br>Self-pick up</td>
						<td class="td_hide_border1"><input type="checkbox" disabled="disabled" name="邮寄（邮寄地址）" value="邮寄（邮寄地址）"  checked="checked">邮寄（邮寄地址）',handlingPostalAddress,'<br>Post (Postal Address)</td>
					</tr>');
	ELSE
		SET htmlOrder1 = 
		CONCAT(htmlOrder1,
		'<div style="border-top: 0px;">
			<table cellpadding="0" cellspacing="0">
				<tbody>
					<tr>
						<td class="td_top1_1" style="width: 20%">样品处理<br>Handling of Specimens</td>
						<td class="td_hide_border1"><input type="checkbox" disabled="disabled" name="委托处理" value="委托处理">委托处理<br>Commissioned Handling</td>
						<td class="td_hide_border1"><input type="checkbox" disabled="disabled" name="自取" value="自取">自取<br>Self-pick up</td>
						<td class="td_hide_border1"><input type="checkbox" disabled="disabled" name="邮寄（邮寄地址）" value="邮寄（邮寄地址）">邮寄（邮寄地址）<br>Post (Postal Address)</td>
					</tr>');
	END IF;

	IF reportPickUp = '自取' THEN
		SET htmlOrder1 = 
		CONCAT(htmlOrder1,
		'	<tr>
						<td>取报告方式<br>Report pick up</td>
						<td class="td_hide_border2"><input type="checkbox" disabled="disabled" name="自取" value="自取" checked="checked">自取<br>Self-pick up</td>
						<td class="td_hide_border2"><input type="checkbox" disabled="disabled" name="传真（号码）" value="传真（号码）">传真（号码）<br>Fax（Number）</td>
						<td class="td_hide_border2"><input type="checkbox" disabled="disabled" name="邮寄（邮寄地址）" value="邮寄（邮寄地址）">邮寄（邮寄地址）<br>Post (Postal Address)</td>
					</tr>
				</tbody>
			</table>
		</div>');

	ELSEIF reportPickUp = '传真' THEN
		SET htmlOrder1 = 
		CONCAT(htmlOrder1,
		'	<tr>
						<td>取报告方式<br>Report pick up</td>
						<td class="td_hide_border2"><input type="checkbox" disabled="disabled" name="自取" value="自取">自取<br>Self-pick up</td>
						<td class="td_hide_border2"><input type="checkbox" disabled="disabled" name="传真（号码）" value="传真（号码）" checked="checked">传真（号码）<br>Fax（Number）</td>
						<td class="td_hide_border2"><input type="checkbox" disabled="disabled" name="邮寄（邮寄地址）" value="邮寄（邮寄地址）">邮寄（邮寄地址）<br>Post (Postal Address)</td>
					</tr>
				</tbody>
			</table>
		</div>');		
	ELSEIF reportPickUp = '邮寄' THEN
		SET htmlOrder1 = 
		CONCAT(htmlOrder1,
		'	<tr>
						<td>取报告方式<br>Report pick up</td>
						<td class="td_hide_border2"><input type="checkbox" disabled="disabled" name="自取" value="自取">自取<br>Self-pick up</td>
						<td class="td_hide_border2"><input type="checkbox" disabled="disabled" name="传真（号码）" value="传真（号码）">传真（号码）<br>Fax（Number）</td>
						<td class="td_hide_border2"><input type="checkbox" disabled="disabled" name="邮寄（邮寄地址）" value="邮寄（邮寄地址）" checked="checked">邮寄（邮寄地址）',reportPostalAddress,'<br>Post (Postal Address)</td>
					</tr>
				</tbody>
			</table>
		</div>');	
	ELSE
		SET htmlOrder1 = 
		CONCAT(htmlOrder1,
		'	<tr>
						<td>取报告方式<br>Report pick up</td>
						<td class="td_hide_border2"><input type="checkbox" disabled="disabled" name="自取" value="自取">自取<br>Self-pick up</td>
						<td class="td_hide_border2"><input type="checkbox" disabled="disabled" name="传真（号码）" value="传真（号码）">传真（号码）<br>Fax（Number）</td>
						<td class="td_hide_border2"><input type="checkbox" disabled="disabled" name="邮寄（邮寄地址）" value="邮寄（邮寄地址）">邮寄（邮寄地址）<br>Post (Postal Address)</td>
					</tr>
				</tbody>
			</table>
		</div>');
	END IF;

	-- 任务名称、收样日期等拼接
	SET htmlOrder1 = 
	CONCAT(htmlORder1,
	'<div style="border-top: 0px;">
		<table cellpadding="0" cellspacing="0">
			<tbody>
				<tr>
					<td class="td_top1_2" style="width: 20%;">任务名称<br>Task Name</td>
					<td class="td_top1_2">',taskName,'</td>
					<td class="td_top1_2">项目令号<br>Project Number</td>
					<td class="td_top1_2">',projectNumber ,'</td>
					<td class="td_top1_2">任务编号<br>Task Number</td>
					<td class="td_top_right1_2">',taskNumber ,'</td>
				</tr>
				<tr>
					<td>收样日期<br>Received Date</td>
					<td>',receivedDate ,'</td>
					<td>要求完成日期<br>Required Date</td>
					<td>',finishDate ,'</td>
					<td>商定完成日期<br>Agreed Date</td>
					<td class="td_rigth">',agreedDate ,'</td>
				</tr>
			</tbody>
		</table>
	</div>');

	-- 材料和任务部分拼接
	-- 判断材料是否存在
	SELECT COUNT(SKF137) INTO countMaterial FROM SKT9 WHERE SKF362 = orderCode AND SKF524 != 1;
	IF countMaterial > 0 THEN
		OPEN cur_1;
		FETCH cur_1 INTO eutID, eutName, eutNumber, modelType,
		eutNo, testStandard, fixtureInformation;
		WHILE done != 1 DO
			SET htmlOrder2 = 
			CONCAT(htmlOrder2,
			'<!-- 检测信息部分 -->
			<div style="border-top: 0px;">
				<table border="0" cellpadding="0" cellspacing="0">
					<tbody>
						<tr>
							<td class="td_top1_1" style="width: 20%;">检测信息<br>Test Information</td>
							<td style="border-top: 0px; border-right: 0px;">
								<div class="div_in">
									<table cellpadding="0" cellspacing="0">
										<tbody>
											<tr>
												<td class="td_top2_1">试样名称<br>Name of EUT</td>
												<td class="td_top2_1">',eutName,'</td>
												<td class="td_top2_1">试样数量<br>Number of EUT</td>
												<td class="td_top_right2_1">',eutNumber,'</td>
											</tr>
											<tr>
												<td>型号/规格<br>Model/Type</td>
												<td>',modelType,'</td>
												<td>试样编号<br>No.of EUT</td>
												<td class="td_rigth">',eutNo,'</td>
											</tr>
											<tr>
												<td>检测依据<br>Test Standard<br>Specification</td>
												<td class="td_rigth" colspan="3">',testStandard,'</td>
											</tr>');

			IF fixtureInformation = '已有' THEN
				SET htmlOrder2 = 
				CONCAT(htmlOrder2,
				'<tr>
					<td rowspan="2">夹具信息<br>Fixture Information</td>
					<td class="td_hide_border2">
						<input type="checkbox" disabled="disabled" name="已有" value="已有" checked="checked">已有 
					</td>
					<td class="td_hide_border2">
						<input type="checkbox" disabled="disabled" name="新制" value="新制">新制
					</td>
					<td class="td_hide_border2">
						<input type="checkbox" disabled="disabled" name="客户提供" value="客户提供">客户提供
					</td>
				</tr>
				<tr>
					<td class="td_hide_border2">
						<input type="checkbox" disabled="disabled" name="邮寄" value="邮寄">邮寄（邮寄地址）
					</td>
					<td class="td_hide_border2"></td>
					<td class="td_hide_border2">
						<input type="checkbox" disabled="disabled" name="实验室存储" value="实验室存储">实验室存储
					</td>
				</tr>
				</tbody></table></div></tbody></table></div>');
			ELSEIF fixtureInformation = '新制' THEN
				SET htmlOrder2 = 
				CONCAT(htmlOrder2,
				'<tr>
					<td rowspan="2">夹具信息<br>Fixture Information</td>
					<td class="td_hide_border2">
						<input type="checkbox" disabled="disabled" name="已有" value="已有">已有 
					</td>
					<td class="td_hide_border2">
						<input type="checkbox" disabled="disabled" name="新制" value="新制" checked="checked">新制
					</td>
					<td class="td_hide_border2">
						<input type="checkbox" disabled="disabled" name="客户提供" value="客户提供">客户提供
					</td>
				</tr>
				<tr>
					<td class="td_hide_border2">
						<input type="checkbox" disabled="disabled" name="邮寄" value="邮寄">邮寄（邮寄地址）
					</td>
					<td class="td_hide_border2"></td>
					<td class="td_hide_border2">
						<input type="checkbox" disabled="disabled" name="实验室存储" value="实验室存储">实验室存储
					</td>
				</tr>
				</tbody></table></div></tbody></table></div>');

			ELSEIF fixtureInformation = '客户提供' THEN
				SET htmlOrder2 = 
				CONCAT(htmlOrder2,
				'<tr>
					<td rowspan="2">夹具信息<br>Fixture Information</td>
					<td class="td_hide_border2">
						<input type="checkbox" disabled="disabled" name="已有" value="已有">已有 
					</td>
					<td class="td_hide_border2">
						<input type="checkbox" disabled="disabled" name="新制" value="新制">新制
					</td>
					<td class="td_hide_border2">
						<input type="checkbox" disabled="disabled" name="客户提供" value="客户提供"  checked="checked">客户提供
					</td>
				</tr>
				<tr>
					<td class="td_hide_border2">
						<input type="checkbox" disabled="disabled" name="邮寄" value="邮寄">邮寄（邮寄地址）
					</td>
					<td class="td_hide_border2"></td>
					<td class="td_hide_border2">
						<input type="checkbox" disabled="disabled" name="实验室存储" value="实验室存储">实验室存储
					</td>
				</tr>
				</tbody></table></div></tbody></table></div>');
			ELSE
				SET htmlOrder2 = 
				CONCAT(htmlOrder2,
				'<tr>
					<td rowspan="2">夹具信息<br>Fixture Information</td>
					<td class="td_hide_border2">
						<input type="checkbox" disabled="disabled" name="已有" value="已有">已有 
					</td>
					<td class="td_hide_border2">
						<input type="checkbox" disabled="disabled" name="新制" value="新制">新制
					</td>
					<td class="td_hide_border2">
						<input type="checkbox" disabled="disabled" name="客户提供" value="客户提供">客户提供
					</td>
				</tr>
				<tr>
					<td class="td_hide_border2">
						<input type="checkbox" disabled="disabled" name="邮寄" value="邮寄">邮寄（邮寄地址）
					</td>
					<td class="td_hide_border2"></td>
					<td class="td_hide_border2">
						<input type="checkbox" disabled="disabled" name="实验室存储" value="实验室存储">实验室存储
					</td>
				</tr>
				</tbody></table></div></tbody></table></div>');

			END IF;

			-- 任务要求表
			SELECT IFNULL(GROUP_CONCAT(SKF180), ''), IFNULL(GROUP_CONCAT(SKF175), ''), 
			IFNULL(GROUP_CONCAT(SKF181), ''),IFNULL(GROUP_CONCAT(SKF182), ''), 
			IFNULL(GROUP_CONCAT(SKF183), '') INTO  testAim, testItem, testMethod,
			criteriaConformity, taskRequirements
			FROM SKT10 WHERE SKF388 = eutID;

			-- 任务要求表拼接
			SET htmlOrder2 = 
			CONCAT(htmlOrder2,
			'<!-- 任务要求部分 -->
			<div style="border-top: 0px;">
				<table border="0" cellpadding="0" cellspacing="0">
					<tbody>
						<tr>
							<td class="td_top1_1" rowspan="6" style="width: 20%;">任务要求<br>Task</td>
							<td class="td_top_right1_1">
								试验及技术要求（检测目的,检测项目,检测方法/条件,合格判据等）<br>
								Test and Technical Requirements (The aim of Test, Test Item, Test Method/Condition, Criteria for Conformity etc.)
							</td>
						</tr>
							<td class="td_rigth3_1">
								检测目的：',testAim,'
							</td>
						<tr>
							<td class="td_rigth3_1">
								检测项目：',testItem,'
							</td>
						</tr>
						<tr>
							<td class="td_rigth3_1">
								检测方法/条件：',testMethod,'
							</td>
						</tr>
						<tr>
							<td class="td_rigth3_1">
								合格判据：',criteriaConformity,'
							</td>
						</tr>
						<tr>
							<td class="td_rigth3_1">
								其他：',taskRequirements,'
							</td>
						</tr>
					</tbody>
				</table>
			</div>');
			FETCH cur_1 INTO eutID, eutName, eutNumber, modelType,
			eutNo, testStandard, fixtureInformation;
		END WHILE;
		CLOSE cur_1;
	ELSE
		SET htmlOrder2 =
		'	<!-- 检测信息部分 -->
			<div style="border-top: 0px;">
				<table border="0" cellpadding="0" cellspacing="0">
					<tbody>
						<tr>
							<td class="td_top1_1" style="width: 20%;">检测信息<br>Test Information</td>
							<td style="border-top: 0px; border-right: 0px;">
								<div class="div_in">
									<table cellpadding="0" cellspacing="0">
										<tbody>
											<tr>
												<td class="td_top2_1">试样名称<br>Name of EUT</td>
												<td class="td_top2_1"></td>
												<td class="td_top2_1">试样数量<br>Number of EUT</td>
												<td class="td_top_right2_1"></td>
											</tr>
											<tr>
												<td>型号/规格<br>Model/Type</td>
												<td></td>
												<td>试样编号<br>No.of EUT</td>
												<td class="td_rigth"></td>
											</tr>
											<tr>
												<td>检测依据<br>Test Standard<br>Specification</td>
												<td class="td_rigth" colspan="3"></td>
											</tr>
											<tr>
												<td rowspan="2">夹具信息<br>Fixture Information</td>
												<td class="td_hide_border2">
													<input type="checkbox" disabled="disabled" name="已有" value="已有">已有 
												</td>
												<td class="td_hide_border2">
													<input type="checkbox" disabled="disabled" name="新制" value="新制">新制
												</td>
												<td class="td_hide_border2">
													<input type="checkbox" disabled="disabled" name="客户提供" value="客户提供">客户提供
												</td>
											</tr>
											<tr>
												<td class="td_hide_border2">
													<input type="checkbox" disabled="disabled" name="邮寄" value="邮寄">邮寄（邮寄地址）
												</td>
												<td class="td_hide_border2">
													
												</td>
												<td class="td_hide_border2">
													<input type="checkbox" disabled="disabled" name="实验室存储" value="实验室存储">实验室存储
												</td>
											</tr>
										</tbody>
									</table>
								</div>
					</tbody>	
				</table>
			</div>
			<!-- 任务要求部分 -->
			<div style="border-top: 0px;">
				<table border="0" cellpadding="0" cellspacing="0">
					<tbody>
						<tr>
							<td class="td_top1_1" rowspan="6" style="width: 20%;">任务要求<br>Task</td>
							<td class="td_top_right1_1">
								试验及技术要求（检测目的,检测项目,检测方法/条件,合格判据等）<br>
								Test and Technical Requirements (The aim of Test, Test Item, Test Method/Condition, Criteria for Conformity etc.)
							</td>
						</tr>
							<td class="td_rigth3_1">
								检测目的：
							</td>
						<tr>
							<td class="td_rigth3_1">
								检测项目：
							</td>
						</tr>
						<tr>
							<td class="td_rigth3_1">
								检测方法/条件：
							</td>
						</tr>
						<tr>
							<td class="td_rigth3_1">
								合格判据：
							</td>
						</tr>
						<tr>
							<td class="td_rigth3_1">
								其他：
							</td>
						</tr>
					</tbody>
				</table>

			</div>';
	END IF;

	-- html后半部分
	SET htmlOrder3 =
		'<div style="border-top: 0px">
			<table cellpadding="0" cellspacing="0">
				<tbody>
					<tr>
						<td class="td_rigth3_1" colspan="2">
							委托单代表<br>
							签字：<br>
							日期：
						</td>
					</tr>
					<tr>
						<td class="td_rigth3_1" colspan="2">
							承制单位代表<br>
							签字：<br>
							日期：
						</td>
					</tr>
					<tr>
						<td>承诺<br>Promise</td>
						<td class="td_rigth3_1">
							委托单位保证对所提供的一切资料、实物的真实性负责。<br>
							本公司保证检测的公正性，对检测数据负责，对委托单位所提供的技术资料保密。<br>
							The client should be responsible for the truth of all documents and objects provided.<br>
							Our company guarantees the impartiality of the test, responsible for the accuracy of testing data and confidentiality of technical <br>
							information provided by the client.
						</td>
					</tr>
				</tbody>
			</table>
		</div>
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