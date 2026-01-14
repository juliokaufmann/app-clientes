-- ============================================
-- FUNÇÕES SQL PARA O SUPABASE (VERSÃO COM BIGINT ID)
-- Use esta versão se os IDs forem BIGINT
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
SET search_path = public, clientes
AS $$
DECLARE
  v_result JSON;
BEGIN
  INSERT INTO clientes.clientes_servicos (
    cliente_id,
    servico_id,
    unidade_id
  ) VALUES (
    p_cliente_id::BIGINT,
    p_servico_id::BIGINT,
    p_unidade_id::BIGINT
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

-- Conceder permissão de execução para a role anon
GRANT EXECUTE ON FUNCTION public.adicionar_cliente_servico(TEXT, TEXT, TEXT) TO anon;
GRANT EXECUTE ON FUNCTION public.adicionar_cliente_servico(TEXT, TEXT, TEXT) TO authenticated;

-- Função para atualizar um serviço atribuído
CREATE OR REPLACE FUNCTION public.atualizar_cliente_servico(
  p_atribuicao_id TEXT,
  p_servico_id TEXT,
  p_unidade_id TEXT
)
RETURNS JSON
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path = public, clientes
AS $$
DECLARE
  v_result JSON;
BEGIN
  UPDATE clientes.clientes_servicos
  SET 
    servico_id = p_servico_id::BIGINT,
    unidade_id = p_unidade_id::BIGINT
  WHERE id = p_atribuicao_id::BIGINT
  RETURNING json_build_object(
    'id', id,
    'cliente_id', cliente_id,
    'servico_id', servico_id,
    'unidade_id', unidade_id
  ) INTO v_result;
  
  RETURN v_result;
END;
$$;

-- Conceder permissão de execução para a role anon
GRANT EXECUTE ON FUNCTION public.atualizar_cliente_servico(TEXT, TEXT, TEXT) TO anon;
GRANT EXECUTE ON FUNCTION public.atualizar_cliente_servico(TEXT, TEXT, TEXT) TO authenticated;

-- Função para remover um serviço atribuído
CREATE OR REPLACE FUNCTION public.remover_cliente_servico(
  p_atribuicao_id TEXT
)
RETURNS JSON
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path = public, clientes
AS $$
DECLARE
  v_result JSON;
BEGIN
  DELETE FROM clientes.clientes_servicos
  WHERE id = p_atribuicao_id::BIGINT
  RETURNING json_build_object(
    'id', id,
    'cliente_id', cliente_id,
    'servico_id', servico_id,
    'unidade_id', unidade_id
  ) INTO v_result;
  
  RETURN v_result;
END;
$$;

-- Conceder permissão de execução para a role anon
GRANT EXECUTE ON FUNCTION public.remover_cliente_servico(TEXT) TO anon;
GRANT EXECUTE ON FUNCTION public.remover_cliente_servico(TEXT) TO authenticated;

-- ============================================
-- NOTAS IMPORTANTES:
-- 1. Esta versão faz cast de TEXT para BIGINT
-- 2. Se os IDs forem UUID, use sql_functions.sql
-- 3. Se os IDs forem TEXT, use sql_functions_text_id.sql
-- ============================================
