-- ============================================
-- FUNÇÕES SQL PARA O SUPABASE (VERSÃO COM TEXT ID)
-- Use esta versão se os IDs forem TEXT ao invés de UUID
-- Execute estas funções no SQL Editor do Supabase
-- ============================================

-- Função para adicionar um serviço a um cliente
CREATE OR REPLACE FUNCTION public.adicionar_cliente_servico(
  p_cliente_id TEXT,
  p_servico_id TEXT,
  p_unidade_id TEXT
)
RETURNS JSON
LANGUAGE plpgsql
SECURITY DEFINER
AS $$
DECLARE
  v_result JSON;
BEGIN
  INSERT INTO clientes.clientes_servicos (
    cliente_id,
    servico_id,
    unidade_id
  ) VALUES (
    p_cliente_id,
    p_servico_id,
    p_unidade_id
  )
  RETURNING json_build_object(
    'id', id,
    'cliente_id', cliente_id,
    'servico_id', servico_id,
    'unidade_id', unidade_id
  ) INTO v_result;
  
  RETURN v_result;
END;
$$;

-- Função para atualizar um serviço atribuído
CREATE OR REPLACE FUNCTION public.atualizar_cliente_servico(
  p_atribuicao_id TEXT,
  p_servico_id TEXT,
  p_unidade_id TEXT
)
RETURNS JSON
LANGUAGE plpgsql
SECURITY DEFINER
AS $$
DECLARE
  v_result JSON;
BEGIN
  UPDATE clientes.clientes_servicos
  SET 
    servico_id = p_servico_id,
    unidade_id = p_unidade_id
  WHERE id = p_atribuicao_id
  RETURNING json_build_object(
    'id', id,
    'cliente_id', cliente_id,
    'servico_id', servico_id,
    'unidade_id', unidade_id
  ) INTO v_result;
  
  RETURN v_result;
END;
$$;

-- Função para remover um serviço atribuído
CREATE OR REPLACE FUNCTION public.remover_cliente_servico(
  p_atribuicao_id TEXT
)
RETURNS JSON
LANGUAGE plpgsql
SECURITY DEFINER
AS $$
DECLARE
  v_result JSON;
BEGIN
  DELETE FROM clientes.clientes_servicos
  WHERE id = p_atribuicao_id
  RETURNING json_build_object(
    'id', id,
    'cliente_id', cliente_id,
    'servico_id', servico_id,
    'unidade_id', unidade_id
  ) INTO v_result;
  
  RETURN v_result;
END;
$$;
