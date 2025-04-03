-- DROP PROCEDURE htmlReport7;
CREATE PROCEDURE htmlReport7(
IN orderCode VARCHAR(255),
OUT pReturn TEXT
)
BEGIN
	-- 委托单位
	DECLARE client VARCHAR(255);
	-- 邮寄地址
	DECLARE postalAddress VARCHAR(255);
	-- 联系人
	DECLARE contact VARCHAR(255);
	-- 联系方式
	DECLARE contactNumber VARCHAR(255);
	-- 任务名称
	DECLARE taskName VARCHAR(255);
	-- 任务编号
	DECLARE taskNumber VARCHAR(255);
	-- 收样日期
	DECLARE receivedOn VARCHAR(255);
	-- 要求完成日期
	DECLARE finishBefore VARCHAR(255);
	-- 商定完成日期
	DECLARE agreedDate VARCHAR(255);
	-- 试验件后处理
	DECLARE afterTest VARCHAR(255);
	-- 取报告方式
	DECLARE reportPickUp VARCHAR(255);

	-- 试验件序号
	DECLARE sampleID VARCHAR(255);
	-- 试验件名称
	DECLARE sampleName VARCHAR(255);
	-- 试验件编号
	DECLARE sampleNumber VARCHAR(255);
	-- 材料类型
	DECLARE materialsType VARCHAR(255);
	-- 生产商名称
	DECLARE manufacturer VARCHAR(255);
	-- 产品批号
	DECLARE batchNumber VARCHAR(255);
	-- 其他需要
	DECLARE otherDescription VARCHAR(255);

	-- 判断试验件是否存在
	DECLARE isSampleExist INT;

	-- 试验依据
	DECLARE testBasis VARCHAR(255);
	-- 测试项目
	DECLARE testItem VARCHAR(255);
	-- 载荷加载方式
	DECLARE loadMode VARCHAR(255);
	-- 载荷控制方式
	DECLARE loadControl VARCHAR(255);
	-- 试验件安装要求和安装方案
	DECLARE installScheme VARCHAR(255);
	-- 夹具信息
	DECLARE fixtureInfo VARCHAR(255);
	-- 试验环境
	DECLARE environment VARCHAR(255);
	-- 应变片粘贴方案和采集要求
	DECLARE strainGauge VARCHAR(255);
	-- 试验过程影像采集要求
	DECLARE imageAcquisition VARCHAR(255);
	-- 其他要求
	DECLARE otherRequirements VARCHAR(255);

	-- 拼接部分定义
	-- 存放HTML
	DECLARE htmlMain TEXT DEFAULT '';
	-- 存放HTML拼接的订单前半部分
	DECLARE htmlOrder1 TEXT DEFAULT '';
	-- 存放材料、任务要求部分
	DECLARE htmlOrder2 TEXT DEFAULT '';
	-- 存放后半部分
	DECLARE htmlOrder3 TEXT DEFAULT '';

	-- 试验件游标定义
	DECLARE done INT DEFAULT 0;
	DECLARE cur_1 CURSOR FOR SELECT
	IFNULL(SKF137,''), IFNULL(SKF138, '') ,IFNULL(SKF280, ''),
	IFNULL(SKF151,''), IFNULL(SKF423, ''), IFNULL(SKF424, ''),
	IFNULL(SKF146, '') FROM SKT9 WHERE SKF362 = orderCode
	AND SKF524 != 1;
	DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = 1;

	-- 委托单主表信息
	SELECT  IFNULL(SKF69, ''), IFNULL(SKF87, ''), IFNULL(SKF71 ,''),
	IFNULL(SKF72, ''),IFNULL(SKF77, ''), IFNULL(SKF79,''),
	IFNULL(SKF80, ''),IFNULL(SKF81,''),IFNULL(SKF82,''),
	IFNULL(SKF88, ''),IFNULL(SKF75,'') INTO 
	client ,postalAddress ,contact ,contactNumber ,taskName ,
	taskNumber ,receivedOn ,finishBefore ,agreedDate ,afterTest ,
	reportPickUp FROM SKT8 WHERE SKF68 = orderCode;

	SET htmlOrder1 = 
	CONCAT('<!DOCTYPE html>
			<html>
			<head>
				<meta charset="gb2312">
				<title>结构强度试验检测委托单</title>
			</head>
			<style type="text/css">
				div{
					border: 1px solid;
					margin: 0px;
					padding: 0px;
				}
				td{
					font-size: 14px;
					text-align: left;
					padding-top: 10px;
					padding-bottom: 0px;
				}
				table{
					width: 100%;
					border-collapse: collapse;
					border: 0px;
					margin-bottom: 10px;
					margin-top: 5px;
				}
				.div_1{
					border: 1px dashed;
					width: 100%;
					font-size: 12px;
				}
				.lable_1{
					text-align: left;
					font-size: 18px;
					font-weight: 600;
					text-decoration: underline;
				}
				.lable_2{
					text-align: left;
					font-size: 14px;
					font-weight: 500;
					background-color: yellow;
				}

				.td_1{
					width: 25%;
					text-align: left;
				}
				.td_1_bottomLine{
					width: 25%;
					border-bottom: 1px solid;
					text-align: left;
				}
				.td_2_bottomLine{
					width: 75%;
					border-bottom: 1px solid;
					text-align: left;
				}
				.div_left{
					vertical-align: top;
					text-align: center;
					font-size: 18px;
					font-weight: 600;
					text-decoration: underline;
					float: left;
					width: 50%;
					height: 80px;
				}
				.div_right{
					vertical-align: top;
					text-align: center;
					font-size: 18px;
					font-weight: 600;
					border-left: 1px;
					text-decoration: underline;
					float: right;
					width: 49.5%;
					height: 80px;
				}

			</style>

			<body>
				<div class="div_1">
					请将表格中以“*”标记的项目填写完整后用电子邮件发送该表格，并为所提供的任何潜在有害物质提供一份MSDS/GHS。我们将在收到您的样品后，向您发送电子邮件，确认收样。<br>
					Please fill out the items with “*” in this form and email this form to us including an MSDS/GHS for any potentially hazardous materials submitted. You will receive an emailed confirmation after your samples have been received.
				</div>
				<label class="lable_1">委托信息 - Request info.</label>
				<div>
					<table>
						<tbody>
							<tr>
								<td class="td_1">*委托单位 Client：</td>
								<td class="td_1_bottomLine"  colspan="3">',client ,'</td>	
							</tr>
							<tr>
								<td class="td_1">*邮寄地址 Postal Address：</td>
								<td class="td_1_bottomLine" colspan="3">',postalAddress ,'</td>
							</tr>
							<tr>
								<td class="td_1">*联系人 Contact：</td>
								<td class="td_1_bottomLine">',contact ,'</td>
								<td class="td_1">*联系方式 Contact Number：</td>
								<td class="td_1_bottomLine">',contactNumber ,'</td>
							</tr>
						</tbody>
					</table>
				</div>
				<div>
					<table>
						<tbody>
							<tr>
								<td class="td_1">任务名称 Task Name：</td>
								<td class="td_1_bottomLine">',taskName ,'</td>
								<td class="td_1">任务编号 Task Number：</td>
								<td class="td_1_bottomLine">',taskNumber ,'</td>
							</tr>
							<tr>
								<td class="td_1">收样日期 Received On：</td>
								<td class="td_1_bottomLine">',receivedOn ,'</td>
								<td></td>
								<td></td>
							</tr>
							<tr>
								<td class="td_1">*要求完成日期 Finish Before：</td>
								<td class="td_1_bottomLine">',finishBefore ,'</td>
								<td class="td_1">商定完成日期Agreed Date：</td>
								<td class="td_1_bottomLine">',agreedDate ,'</td>
							</tr>');

	-- 试验件后处理部分
	IF afterTest = '放弃' THEN
		SET htmlOrder1 = 
		CONCAT(htmlOrder1,
			'<tr>
					<td class="td_1">*试验件后处理 After Test：</td>
					<td class="td_1"><input type="checkbox" disabled="disabled" name="放弃" checked="checked">放弃 Give up</td>
					<td class="td_1"><input type="checkbox" disabled="disabled" name="自取">自取 Self-pick up</td>
					<td class="td_1"><input type="checkbox" disabled="disabled" name="邮寄">邮寄 Post</td>
				</tr>');
	ELSEIF afterTest = '自取' THEN
		SET htmlOrder1 = 
		CONCAT(htmlOrder1,
			'<tr>
					<td class="td_1">*试验件后处理 After Test：</td>
					<td class="td_1"><input type="checkbox" disabled="disabled" name="放弃" >放弃 Give up</td>
					<td class="td_1"><input type="checkbox" disabled="disabled" name="自取" checked="checked">自取 Self-pick up</td>
					<td class="td_1"><input type="checkbox" disabled="disabled" name="邮寄">邮寄 Post</td>
				</tr>');
	ELSEIF afterTest = '邮寄' THEN
		SET htmlOrder1 = 
		CONCAT(htmlOrder1,
			'<tr>
					<td class="td_1">*试验件后处理 After Test：</td>
					<td class="td_1"><input type="checkbox" disabled="disabled" name="放弃" >放弃 Give up</td>
					<td class="td_1"><input type="checkbox" disabled="disabled" name="自取">自取 Self-pick up</td>
					<td class="td_1"><input type="checkbox" disabled="disabled" name="邮寄" checked="checked">邮寄 Post</td>
				</tr>');
	ELSE 
		SET htmlOrder1 = 
		CONCAT(htmlOrder1,
			'<tr>
					<td class="td_1">*试验件后处理 After Test：</td>
					<td class="td_1"><input type="checkbox" disabled="disabled" name="放弃">放弃 Give up</td>
					<td class="td_1"><input type="checkbox" disabled="disabled" name="自取">自取 Self-pick up</td>
					<td class="td_1"><input type="checkbox" disabled="disabled" name="邮寄">邮寄 Post</td>
				</tr>');
	END IF;
	-- 取报告方式部分
	IF reportPickUp = '自取' THEN
		SET htmlOrder1 = 
		CONCAT(htmlOrder1, 
			'			<tr>
							<td class="td_1">*取报告方式 Report Pick up：</td>
							<td class="td_1"><input type="checkbox" disabled="disabled" value="自取" checked="checked">自取 Self-pick up</td>
							<td class="td_1"><input type="checkbox" disabled="disabled" value="传真">传真 Fax</td>
							<td class="td_1"><input type="checkbox" disabled="disabled" value="邮寄">邮寄 Post</td>
						</tr>
					</tbody>
				</table>
			</div>');
	ELSEIF reportPickUp = '传真' THEN
		SET htmlOrder1 = 
		CONCAT(htmlOrder1, 
			'			<tr>
							<td class="td_1">*取报告方式 Report Pick up：</td>
							<td class="td_1"><input type="checkbox" disabled="disabled" value="自取">自取 Self-pick up</td>
							<td class="td_1"><input type="checkbox" disabled="disabled" value="传真" checked="checked">传真 Fax</td>
							<td class="td_1"><input type="checkbox" disabled="disabled" value="邮寄">邮寄 Post</td>
						</tr>
					</tbody>
				</table>
			</div>');
	ELSEIF reportPickUp = '邮寄' THEN
		SET htmlOrder1 = 
		CONCAT(htmlOrder1, 
			'			<tr>
							<td class="td_1">*取报告方式 Report Pick up：</td>
							<td class="td_1"><input type="checkbox" disabled="disabled" value="自取">自取 Self-pick up</td>
							<td class="td_1"><input type="checkbox" disabled="disabled" value="传真">传真 Fax</td>
							<td class="td_1"><input type="checkbox" disabled="disabled" value="邮寄" checked="checked">邮寄 Post</td>
						</tr>
					</tbody>
				</table>
			</div>');
	ELSE
		SET htmlOrder1 = 
		CONCAT(htmlOrder1, 
			'			<tr>
							<td class="td_1">*取报告方式 Report Pick up：</td>
							<td class="td_1"><input type="checkbox" disabled="disabled" value="自取">自取 Self-pick up</td>
							<td class="td_1"><input type="checkbox" disabled="disabled" value="传真">传真 Fax</td>
							<td class="td_1"><input type="checkbox" disabled="disabled" value="邮寄">邮寄 Post</td>
						</tr>
					</tbody>
				</table>
			</div>');
	END IF;

	-- 判断试验件是否存在
	SELECT COUNT(SKF137) INTO isSampleExist FROM SKT9 WHERE SKF362 = orderCode AND SKF524 != 1;
	IF isSampleExist > 0 THEN
		OPEN cur_1;
		FETCH cur_1 INTO sampleID ,sampleName ,sampleNumber ,materialsType ,manufacturer ,
		batchNumber ,otherDescription;
		WHILE done != 1 DO
			SELECT IFNULL(GROUP_CONCAT(SKF179), ''), IFNULL(GROUP_CONCAT(SKF175), ''), IFNULL(GROUP_CONCAT(SKF415), ''),
			IFNULL(GROUP_CONCAT(SKF416), ''),IFNULL(GROUP_CONCAT(SKF417), '') , IFNULL(GROUP_CONCAT(SKF351), ''), 
			IFNULL(GROUP_CONCAT(SKF173), ''),IFNULL(GROUP_CONCAT(SKF418), ''),IFNULL(GROUP_CONCAT(SKF419), ''), 
			IFNULL(GROUP_CONCAT(SKF186), '') INTO 
			testBasis, testItem ,loadMode , 
			loadControl,installScheme ,fixtureInfo ,
			environment ,strainGauge ,imageAcquisition ,
			otherRequirements 
			FROM SKT10 WHERE SKF388 = sampleID;

			SET htmlOrder2 = 
			CONCAT(htmlOrder2,
				'<label class="lable_1">试验件基本信息 Specimen info.</label>
					<div>
						<table>
							<tbody>
								<tr>
									<td class="td_1">试验件名称：</td>
									<td class="td_1_bottomLine">',sampleName,'</td>
									<td class="td_1">*试验件编号 Sample Number：</td>
									<td class="td_1_bottomLine">',sampleNumber,'</td>
								</tr>');

			IF materialsType = '金属' THEN
				SET htmlOrder2 = 
				CONCAT(htmlOrder2,
					'<tr>
							<td class="td_1">*材料类型 Materals type：</td>
							<td class="td_1_bottomLine">
								<input type="checkbox" disabled="disabled" name="金属" checked="checked">金属
								<input type="checkbox" disabled="disabled" name="非金属">非金属
								<input type="checkbox" disabled="disabled" name="其他">其他
							</td>
					</tr>');
			ELSEIF materialsType = '非金属' THEN
				SET htmlOrder2 = 
				CONCAT(htmlOrder2,
					'<tr>
							<td class="td_1">*材料类型 Materals type：</td>
							<td class="td_1_bottomLine">
								<input type="checkbox" disabled="disabled" name="金属">金属
								<input type="checkbox" disabled="disabled" name="非金属" checked="checked">非金属
								<input type="checkbox" disabled="disabled" name="其他">其他
							</td>
					</tr>');
			ELSEIF materialsType = '其他' THEN
				SET htmlOrder2 = 
				CONCAT(htmlOrder2,
					'<tr>
							<td class="td_1">*材料类型 Materals type：</td>
							<td class="td_1_bottomLine">
								<input type="checkbox" disabled="disabled" name="金属">金属
								<input type="checkbox" disabled="disabled" name="非金属">非金属
								<input type="checkbox" disabled="disabled" name="其他" checked="checked">其他
							</td>
					</tr>');
			ELSE 
				SET htmlOrder2 = 
				CONCAT(htmlOrder2,
					'<tr>
							<td class="td_1">*材料类型 Materals type：</td>
							<td class="td_1_bottomLine">
								<input type="checkbox" disabled="disabled" name="金属">金属
								<input type="checkbox" disabled="disabled" name="非金属">非金属
								<input type="checkbox" disabled="disabled" name="其他">其他
							</td>
					</tr>');
			END IF;

			SET htmlOrder2 = 
			CONCAT(htmlOrder2,
			'				<tr>
								<td class="td_1">*生产商名称 Manufacturer：</td>
								<td class="td_1_bottomLine">',manufacturer,'</td>
								<td class="td_1">*产品批号 Batch/Lot Number：</td>
								<td class="td_1_bottomLine">',batchNumber,'</td>
							</tr>
							<tr>
								<td class="td_1">其他需要在检测报告中说明的试验件信息：</td>
								<td class="td_1_bottomLine" colspan="3">',otherDescription,'</td>
							</tr>
						</tbody>
					</table>
				</div>
				<label class="lable_1">试验要求 - Test Requirements</label>
					<div>
						<table>
							<tbody>
								<tr>
									<td class="td_1">*试验依据（提供试验大纲）：</td>
									<td class="td_2_bottomLine">',testBasis,'</td>
								</tr>
								<tr>
									<td class="td_1">*测试项目：</td>
									<td class="td_2_bottomLine">',testItem,'</td>
								</tr>');

			IF loadMode LIKE '%连续加载%' THEN
				SET htmlOrder2 = 
				CONCAT(htmlOrder2,
					'								
								<tr>
									<td class="td_1">*载荷加载方式：</td>
									<td class="td_2_bottomLine">
										<input type="checkbox" disabled="disabled" name="连续加载；" checked="checked">连续加载；
										<input type="checkbox" disabled="disabled" name="分级加载（需提级加载步骤）">分级加载（需提级加载步骤）
									</td>
								</tr>');

			ELSEIF loadMode LIKE '%分级加载%' THEN
				SET htmlOrder2 = 
				CONCAT(htmlOrder2,
					'								
								<tr>
									<td class="td_1">*载荷加载方式：</td>
									<td class="td_2_bottomLine">
										<input type="checkbox" disabled="disabled" name="连续加载；">连续加载；
										<input type="checkbox" disabled="disabled" name="分级加载（需提级加载步骤）"  checked="checked">分级加载（需提级加载步骤）
									</td>
								</tr>');

			ELSE
				SET htmlOrder2 = 
				CONCAT(htmlOrder2,
					'								
								<tr>
									<td class="td_1">*载荷加载方式：</td>
									<td class="td_2_bottomLine">
										<input type="checkbox" disabled="disabled" name="连续加载；">连续加载；
										<input type="checkbox" disabled="disabled" name="分级加载（需提级加载步骤）">分级加载（需提级加载步骤）
									</td>
								</tr>');
			END IF;

			SET htmlOrder2 = 
			CONCAT(htmlOrder2,
				'
								<tr>
									<td class="td_1">*载荷控制方式：</td>
									<td class="td_2_bottomLine">',loadControl,'</td>
								</tr>
								<tr>
									<td class="td_1">*试验件安装要求和安装方案：</td>
									<td class="td_2_bottomLine">',installScheme,'</td>
								</tr>');
			IF fixtureInfo = '已有' THEN
				SET htmlOrder2 =
				CONCAT(htmlOrder2,
					'<tr>
									<td class="td_1">*夹具信息 Fixture  Info.：</td>
									<td class="td_2_bottomLine">
										<input type="checkbox" disabled="disabled" name="已有" checked="checked">已有
										<input type="checkbox" disabled="disabled" name="新制">新制
										<input type="checkbox" disabled="disabled" name="客户提供">客户提供
									</td>
								</tr>');
			ELSEIF fixtureInfo = '新制' THEN
				SET htmlOrder2 =
				CONCAT(htmlOrder2,
					'<tr>
									<td class="td_1">*夹具信息 Fixture  Info.：</td>
									<td class="td_2_bottomLine">
										<input type="checkbox" disabled="disabled" name="已有">已有
										<input type="checkbox" disabled="disabled" name="新制" checked="checked">新制
										<input type="checkbox" disabled="disabled" name="客户提供">客户提供
									</td>
								</tr>');
			ELSEIF fixtureInfo = '客户提供' THEN
				SET htmlOrder2 =
				CONCAT(htmlOrder2,
					'<tr>
									<td class="td_1">*夹具信息 Fixture  Info.：</td>
									<td class="td_2_bottomLine">
										<input type="checkbox" disabled="disabled" name="已有">已有
										<input type="checkbox" disabled="disabled" name="新制">新制
										<input type="checkbox" disabled="disabled" name="客户提供" checked="checked">客户提供
									</td>
								</tr>');
			ELSE 
				SET htmlOrder2 =
				CONCAT(htmlOrder2,
					'<tr>
									<td class="td_1">*夹具信息 Fixture  Info.：</td>
									<td class="td_2_bottomLine">
										<input type="checkbox" disabled="disabled" name="已有">已有
										<input type="checkbox" disabled="disabled" name="新制">新制
										<input type="checkbox" disabled="disabled" name="客户提供">客户提供
									</td>
								</tr>');
			END IF;

			SET htmlOrder2 = 
			CONCAT(htmlOrder2,				
			'					<tr>
									<td class="td_1">*试验环境 Environment：</td>
									<td class="td_2_bottomLine">',environment,'</td>
								</tr>
								<tr>
									<td class="td_1">*应变黏贴方案和采集要求：</td>
									<td class="td_2_bottomLine">',strainGauge,'</td>
								</tr>
								<tr>
									<td class="td_1">*试验过程影像采集要求：</td>
									<td class="td_2_bottomLine">',imageAcquisition,'</td>
								</tr>
								<tr>
									<td class="td_1">*其他要求Other Requirements：</td>
									<td class="td_2_bottomLine">',otherRequirements,'</td>
								</tr>
								<tr>
									<td colspan="2"><label class="lable_2">注：具体大纲方案要求等请以附件形式附在委托单后。</label></td>
								</tr>
							</tbody>
						</table>
					</div>');
			FETCH cur_1 INTO sampleID ,sampleName ,sampleNumber ,materialsType ,manufacturer ,
			batchNumber ,otherDescription;
		END WHILE;
		CLOSE cur_1;
	ELSE
		SET htmlOrder2 = 
		'<label class="lable_1">试验件基本信息 Specimen info.</label>
		<div>
			<table>
				<tbody>
					<tr>
						<td class="td_1">试验件名称：</td>
						<td class="td_1_bottomLine"></td>
						<td class="td_1">*试验件编号 Sample Number：</td>
						<td class="td_1_bottomLine"></td>
					</tr>
					<tr>
						<td class="td_1">*材料类型 Materals type：</td>
						<td class="td_1_bottomLine">
							<input type="checkbox" disabled="disabled" name="金属">金属
							<input type="checkbox" disabled="disabled" name="非金属">非金属
							<input type="checkbox" disabled="disabled" name="其他">其他
						</td>
					</tr>
					<tr>
						<td class="td_1">*生产商名称 Manufacturer：</td>
						<td class="td_1_bottomLine"></td>
						<td class="td_1">*产品批号 Batch/Lot Number：</td>
						<td class="td_1_bottomLine"></td>
					</tr>
					<tr>
						<td class="td_1">其他需要在检测报告中说明的试验件信息：</td>
						<td class="td_1_bottomLine" colspan="3"></td>
					</tr>
				</tbody>
			</table>
		</div>
		<label class="lable_1">试验要求 - Test Requirements</label>
		<div>
			<table>
				<tbody>
					<tr>
						<td class="td_1">*试验依据（提供试验大纲）：</td>
						<td class="td_2_bottomLine"></td>
					</tr>
					<tr>
						<td class="td_1">*测试项目：</td>
						<td class="td_2_bottomLine"></td>
					</tr>
					<tr>
						<td class="td_1">*载荷加载方式：</td>
						<td class="td_2_bottomLine">
							<input type="checkbox" disabled="disabled" name="连续加载；">连续加载；
							<input type="checkbox" disabled="disabled" name="分级加载（需提级加载步骤）">分级加载（需提级加载步骤）
						</td>
					</tr>
					<tr>
						<td class="td_1">*载荷控制方式：</td>
						<td class="td_2_bottomLine">力控 N/min；&nbsp;&nbsp;&nbsp;位控 mm/min</td>
					</tr>
					<tr>
						<td class="td_1">*试验件安装要求和安装方案：</td>
						<td class="td_2_bottomLine"></td>
					</tr>
					<tr>
						<td class="td_1">*夹具信息 Fix Info.：</td>
						<td class="td_2_bottomLine">
							<input type="checkbox" disabled="disabled" name="已有">已有
							<input type="checkbox" disabled="disabled" name="新制">新制
							<input type="checkbox" disabled="disabled" name="客户提供">客户提供
						</td>
					</tr>
					<tr>
						<td class="td_1">*试验环境 Environment：</td>
						<td class="td_2_bottomLine"></td>
					</tr>
					<tr>
						<td class="td_1">*应变黏贴方案和采集要求：</td>
						<td class="td_2_bottomLine"></td>
					</tr>
					<tr>
						<td class="td_1">*试验过程影像采集要求：</td>
						<td class="td_2_bottomLine"></td>
					</tr>
					<tr>
						<td class="td_1">*其他要求Other Requirements：</td>
						<td class="td_2_bottomLine"></td>
					</tr>
					<tr>
						<td colspan="2"><label class="lable_2">注：具体大纲方案要求等请以附件形式附在委托单后。</label></td>
					</tr>
				</tbody>
			</table>
		</div>';
	END IF;

	SET htmlOrder3 = 
	'		<div>
			委托方保证对所提供的一切资料、实物的真实性负责。<br>
			本公司保证检测的公正性，对检测数据负责，对委托单位所提供的技术资料保密。<br>
			The client should be responsible for the truth of all documents and objects provided.<br>
			Our company guarantees the impartiality of the test, responsible for the accuracy of testing data and confidentiality of technical information provided by the client.
		</div>
		<div class="div_left">
			委托方代表 - Client Signature / Date:
		</div>
		<div class="div_right">
			上航检测代表 - SAMST Signature / Date:
		</div>
		<label>&nbsp;</label>
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
